require "erb"

signer = "test@example.com" # an email address. It doesn't have to be real. This is your so-called "Signer ID".
path = "/var/www/i2pseed" # wwwroot
i2pjar = "/usr/share/i2p/lib/i2p.jar" # the path to your i2p.jar file (this can be /usr/share/i2p/lib/i2p.jar, for example).

def randomcode len=64
  symbols = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
  res = ""
  rnd = Random.new
  for i in 0...len
    res += symbols[rnd.rand(0...symbols.length)]
  end
  return res
end

File.write "private/private-2s.pw", randomcode
system("rm private/private-2s.ks") if File.exist? "private/private-2s.ks"
system("rm private/#{signer}.crt") if File.exist? "private/#{signer}.crt"
system("java -cp #{i2pjar} net.i2p.crypto.SU3File keygen -t RSA_SHA512_4096 private/#{signer}.crt private/private-2s.ks #{signer} < private/private-2s.pw")
system("cp private/#{signer}.crt public/#{signer}.crt")

File.write "cronjob.php", ERB.new(File.read("../templates/cronjob.php.erb")).result
File.write "public/index.html", ERB.new(File.read("../templates/index.html.erb")).result
