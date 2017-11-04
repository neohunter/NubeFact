class NubeFact::Document
  include NubeFact::Validator
  include NubeFact::Utils

  FIELDS = [
    "operacion",
    "tipo_de_comprobante", 
      # 1=FACTURA 
      # 2=BOLETA 
      # 3=NOTA CREDITO 
      # 4=NOTA DEBITO
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

    # Nota de credito    
    "documento_que_se_modifica_tipo",
      # 1 = ANULACIÓN DE LA OPERACIÓN
      # 2 = ANULACIÓN POR ERROR EN EL RUC
      # 3 = CORRECCIÓN POR ERROR EN LA DESCRIPCIÓN
      # 4 = DESCUENTO GLOBAL
      # 5 = DESCUENTO POR ÍTEM
      # 6 = DEVOLUCIÓN TOTAL
      # 7 = DEVOLUCIÓN POR ÍTEM
      # 8 = BONIFICACIÓN
      # 9 = DISMINUCIÓN EN EL VALOR

    "documento_que_se_modifica_serie",
    "documento_que_se_modifica_numero",
    
    "tipo_de_nota_de_credito",
    "tipo_de_nota_de_debito",
    
    "enviar_automaticamente_a_la_sunat",
    "enviar_automaticamente_al_cliente",
    
    "codigo_unico",
    "condiciones_de_pago",
    "medio_de_pago",
      # Ejemplo: TARJETA VISA OP: 232231
    "placa_vehiculo",
    "orden_compra_servicio",
    "tabla_personalizada_codigo",
    "formato_de_pdf",
      # A4, A5 o TICKET.

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

  def initialize(data_hash)
    if self.class == NubeFact::Document
      raise "Don't initialize NubeFact::Document directly "
    end

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
        tipo_de_comprobante: self::TIPO_DE_COMPROBANTE,
        serie: serie,
        numero: numero
      })
    end 

    def anular(serie, numero, motivo)
      NubeFact.request({
        operacion: "generar_anulacion",
        tipo_de_comprobante: self::TIPO_DE_COMPROBANTE,
        serie: serie,
        numero: numero,
        motivo: motivo
      })
    end
  end

end