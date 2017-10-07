class NubeFact::Invoice
  attr_accessor "operacion",
        "tipo_de_comprobante",
        "serie",
        "numero",
        "sunat_transaction",
        "cliente_tipo_de_documento",
        "cliente_numero_de_documento",
        "cliente_denominacion",
        "cliente_direccion",
        "cliente_email",
        "cliente_email_1",
        "cliente_email_2",
        "fecha_de_emision",
        "fecha_de_vencimiento",
        "moneda",
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

  attr_accessor :items, :guias

  def initialize(data_hash = {})
    @items = []
    @guias = []

    data_hash.each do|key, value|
      instance_variable_set "@#{key}", value
    end
  end

  def add_item(item)

  end

  def add_guia(guia)

  end
end