require 'net/http'
require 'uri'
require 'json'

unless ARGV.count() == 2
  abort("Need Apple Developer username and password")
end

@username, @password = ARGV

@cookies_array = Array.new

def sign_in(username, password)

  uri = URI("https://idmsa.apple.com/appleauth/auth/signin")
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true

  request = Net::HTTP::Post.new(uri.path)

  data = {
      accountName: username,
      password: password,
      rememberMe: true
  }

  request.body = data.to_json

  request['Content-Type'] = 'application/json'
  request['X-Requested-With'] = 'XMLHttpRequest'
  request['X-Apple-Widget-Key'] = itc_service_key
  request['Accept'] = 'application/json, text/javascript'

  response = https.request(request)
  save_cookies response
end

def fetch_olympus_session
  uri = URI("https://olympus.itunes.apple.com/v1/session")
  req = Net::HTTP::Get.new(uri)
  req['Cookie'] = @cookies

  response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {|http|
    http.request(req)
  }

  save_cookies response
end

def itc_service_key
  uri = URI.parse("https://olympus.itunes.apple.com/v1/app/config?hostname=itunesconnect.apple.com")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  response = http.get(uri.request_uri)
  result = JSON.parse(response.body)
  return result['authServiceKey']
end


def save_cookies(response)
  all_cookies = response.get_fields('set-cookie')

  all_cookies.each { | cookie |
    cookie.gsub! '; ', ';'
    cookie.gsub! ';', '; '
    @cookies_array.push(cookie.split('; ')[0])
  }
  @cookies = @cookies_array.join('; ')
end

sign_in @username, @password
fetch_olympus_session
puts @cookies
