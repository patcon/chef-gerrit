maintainer       "Myplanet Digital"
maintainer_email "patrick@myplanetdigital.com"
license          "GNU Public License 3.0"
description      "Installs/Configures gerrit"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{ build-essential mysql database java git }.each do |cookbook|
  depends cookbook
end
