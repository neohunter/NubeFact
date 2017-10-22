# https://docs.google.com/document/d/1QWWSILBbjd4MDkJl7vCkL2RZvkPh0IC7Wa67BvoYIhA/edit


class NubeFact::Invoice
  include NubeFact::Validator
  include NubeFact::Utils

  FIELDS = [
    "operacion",
    "tipo_de_comprobante", # 1=FACTURA 2=BOLETA 3=NOTA CREDITO 4 NOTA DEBITO
    "serie", # F para FACTURA | B PARA BOLETA
    "numero",
    "sunat_transaction",      
      # 1 = VENTA INTERNA
      # 2 = EXPORTACIÓN
      # 3 = NO DOMICILIADO
      # 4 = VENTA INTERNA – ANTICIPOS
      # 5 = VENTA ITINERANTE
      # 6 = FACTURA GUÍA
      # 7 = VENTA ARROZ PILADO
      # 8 = FACTURA - COMPROBANTE DE PERCEPCIÓN
      # 10 = FACTURA - GUÍA REMITENTE
      # 11 = FACTURA - GUÍA TRANSPORTISTA
      # 12 = BOLETA DE VENTA – COMPROBANTE DE PERCEPCIÓN
      # 13 = GASTO DEDUCIBLE PERSONA NATURAL

    "cliente_tipo_de_documento",
      # 6 = RUC - REGISTRO ÚNICO DE CONTRIBUYENTE
      # 1 = DNI - DOC. NACIONAL DE IDENTIDAD
      # - = VARIOS - VENTAS MENORES A S/.700.00 Y OTROS
      # 4 = CARNET DE EXTRANJERÍA
      # 7 = PASAPORTE
      # A = CÉDULA DIPLOMÁTICA DE IDENTIDAD
      # 0 = NO DOMICILIADO, SIN RUC (EXPORTACIÓN)

    "cliente_numero_de_documento",
    "cliente_denominacion",
    "cliente_direccion",
    "cliente_email",
    "cliente_email_1",
    "cliente_email_2",

    "fecha_de_emision",
    "fecha_de_vencimiento",
    "moneda",
      # 1 = SOLES
      # 2 = DÓLARES
      # 3 = EUROS
    "tipo_de_cambio",

    "porcentaje_de_igv",
    "descuento_global",
    "total_descuento",
    "total_anticipo",
    "total_gravada",
    "total_inafecta",
    "total_exonerada",
    "total_igv",
    "total_gratuita",
    "total_otros_cargos",
    "total",

    "percepcion_tipo",
    "percepcion_base_imponible",
    "total_percepcion",
    "total_incluido_percepcion",
    "detraccion",

    "observaciones",
    
    "documento_que_se_modifica_tipo",
    "documento_que_se_modifica_serie",
    "documento_que_se_modifica_numero",
    
    "tipo_de_nota_de_credito",
    "tipo_de_nota_de_debito",
    
    "enviar_automaticamente_a_la_sunat",
    "enviar_automaticamente_al_cliente",
    
    "codigo_unico",
    "condiciones_de_pago",
    "medio_de_pago",
    "placa_vehiculo",
    "orden_compra_servicio",
    "tabla_personalizada_codigo",
    "formato_de_pdf",

    "items",
    "guias"
  ]
  
  attr_accessor *FIELDS

  REQUIRED_FIELDS = %i(
    serie
    numero
    sunat_transaction
    cliente_tipo_de_documento
    cliente_numero_de_documento
    cliente_denominacion
    cliente_direccion
    fecha_de_emision
    moneda
    porcentaje_de_igv
    total
  )

  DEFAULT_DATA = {
                  operacion: 'generar_comprobante',
        tipo_de_comprobante: 1,     
                      serie: 'F',   
          sunat_transaction: 1,
           fecha_de_emision: ->(_i) { Date.today },
          porcentaje_de_igv: 18,
                     moneda: 1,
             tipo_de_cambio: ->(invoice) { invoice.set_tipo_de_cambio } 
  }

  def initialize(data_hash)
    @items = []
    @guias = []

    load_data_from_param data_hash
  end

  def add_item(item)
    if item.is_a? Hash
      item = Item.new self, item
    end
    @items << item
  end

  def add_guia(guia)

  end

  def deliver
    if items.empty?
      raise NubeFact::ValidationError.new "At least one item have to be present"
    end
    validate!

    NubeFact.request to_h
  end

  def calculate_amounts

  end

  def set_tipo_de_cambio
    return "" unless moneda == 2
    NubeFact::Sunat.dollar_rate Date.parse(fecha_de_emision)
  end


  def fecha_de_emision
    if [Date, Time, DateTime].include? @fecha_de_emision.class
      return @fecha_de_emision.strftime(NubeFact::DATE_FORMAT)
    end
    @fecha_de_emision
  end

  class << self
    def consultar(serie, numero)
      NubeFact.request({
        operacion: "consultar_comprobante",
        tipo_de_comprobante: 1,
        serie: serie,
        numero: numero
      })
    end 
  end

end