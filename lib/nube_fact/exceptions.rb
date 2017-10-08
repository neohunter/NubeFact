# CÓDIGO - DESCRIPCIÓN
# 10 - No se pudo autenticar, token incorrecto o eliminado
# 11 - La ruta o URL que estás usando no es correcta o no existe. 
#      Ingresa a tu cuenta en www.nubefact.com en la opción Api-Integración para verificar este dato
# 12 - Solicitud incorrecta, la cabecera (Header) no contiene un Content-Type correcto
# 20 - El archivo enviado no cumple con el formato establecido
# 21 - No se pudo completar la operación, se acompaña el problema con un mensaje
# 22 - Documento enviado fuera del plazo permitido
# 23 - Este documento ya existe en NubeFacT
# 24 - El documento indicado no existe o no fue enviado a NubeFacT
# 40 - Error interno desconocido
# 50 - Su cuenta ha sido suspendida
# 51 - Su cuenta ha sido suspendida por falta de pago

module NubeFact
  # Request Related
  class NotConfigured < StandardError; end
  class ErrorResponse < StandardError; end

  # Data Related
  class ValidationError < StandardError; end
  class InvalidField < StandardError; end
end