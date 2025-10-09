require 'webrick'

class WebServer < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    case request.path
    when "/"
      response.status = 200
      response['Content-Type'] = 'text/plain'
      response.body = 'Hello, World'
    when "/api"
      response.status = 201
      response['Content-Type'] = 'application/json'
      response.body = '{"foo":"bar"}'
    else
      response.status = 404
      response['Content-Type'] = 'text/plain'
      response.body = 'Not Found'
    end
  end
end

# Esto solo se ejecutará si este script fue llamado directamente desde
# la CLI, pero no si fue requerido desde otro archivo
if __FILE__ == $0
  # Ejecutar el servidor en localhost en el puerto 8000
  server = WEBrick::HTTPServer.new :Port => 8000
  server.mount '/', WebServer
  # Apagar el servidor con CTRL+C
  trap 'INT' do server.shutdown end
  # Iniciar el servidor
  server.start
end