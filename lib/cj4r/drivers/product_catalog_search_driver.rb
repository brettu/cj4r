require 'cj4r/drivers/product_catalog_search.rb'
require 'cj4r/drivers/product_catalog_search_mapping_registry.rb'

class ProductSearchServiceV2PortType < ::SOAP::RPC::Driver
  DefaultEndpointUrl = "https://product.api.cj.com/services/productSearchServiceV2"

  Methods = [
    [ "",
      "search",
      [ ["in", "parameters", ["::SOAP::SOAPElement", "http://api.cj.com", "search"]],
        ["out", "parameters", ["::SOAP::SOAPElement", "http://api.cj.com", "searchResponse"]] ],
      { :request_style =>  :document, :request_use =>  :literal,
        :response_style => :document, :response_use => :literal,
        :faults => {} }
    ]
  ]

  def initialize(endpoint_url = nil)
    endpoint_url ||= DefaultEndpointUrl
    super(endpoint_url, nil)
    self.mapping_registry = DefaultMappingRegistry::ProductEncodedRegistry
    self.literal_mapping_registry = DefaultMappingRegistry::ProductLiteralRegistry
    init_methods
  end

private

  def init_methods
    Methods.each do |definitions|
      opt = definitions.last
      if opt[:request_style] == :document
        add_document_operation(*definitions)
      else
        add_rpc_operation(*definitions)
        qname = definitions[0]
        name = definitions[2]
        if qname.name != name and qname.name.capitalize == name.capitalize
          ::SOAP::Mapping.define_singleton_method(self, qname.name) do |*arg|
            __send__(name, *arg)
          end
        end
      end
    end
  end
end