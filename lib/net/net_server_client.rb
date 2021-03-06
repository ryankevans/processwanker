############################################################################
#
# net_server_client.rb
#
# server's view of a client connection
#
############################################################################

require 'openssl'
require 'config'
require 'net_util'
require 'socket'
require 'net_connection'
require 'thread'

module ProcessWanker
	
  ############################################################################
  #
  #
  #
  ############################################################################

	class NetServerClient < NetConnection
	
	  ############################################################################
	  #
	  #
	  #
	  ############################################################################

		def initialize(ssl_connection,server)
			@server=server
			super(ssl_connection)
		end

	  ############################################################################
	  #
	  #
	  #
	  ############################################################################
	
		def on_msg(msg)
			super(msg)
			ProcessWanker::with_logged_rescue("NetServerClient::on_msg") do
				resp=NetApi::execute(msg,self)
				if(resp)
					debug("send resp #{resp.inspect}")
					resp[:done]=true
					send_msg(resp)
				end			
			end
		end
	
	  ############################################################################
	  #
	  #
	  #
	  ############################################################################
	
		def inform(msg)
			send_msg( { :info => msg } )
		end
	
	  ############################################################################
	  #
	  #
	  #
	  ############################################################################
	
		def on_close()
			super()
			@server.client_closed(self)
		end
	
	  ############################################################################
	  #
	  #
	  #
	  ############################################################################
	
	end

end
