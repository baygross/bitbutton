def self.get_or_post(url,&block)
  get(url,&block)
  post(url,&block)
end

def log(x)
  p "*****" + x + "*****"
end


get_or_post '/hello-world' do
  log "begin /hello-world"
  p params
  "hello world"
end
