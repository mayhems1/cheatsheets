# OpenSSL Cheat Sheat

## Using openssl to get the certificate from a server

```bash
openssl s_client -showcerts -connect kolesa.group:443 </dev/null
# or
openssl s_client -connect kolesa.group:443 2>/dev/null </dev/null |  sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'
```

## Convert pfx file to pem file

Conversion to a combined PEM file

```bash
# To convert a PFX file to a PEM file that contains both the certificate and private key, the following command needs to be used:
openssl pkcs12 -in filename.pfx -out cert.pem -nodes 

# Conversion to separate PEM files
# We can extract the private key form a PFX to a PEM file with this command:
openssl pkcs12 -in filename.pfx -nocerts -out key.pem

# Exporting the certificate only:
openssl pkcs12 -in filename.pfx -clcerts -nokeys -out cert.pem

# Removing the password from the extracted private key:
openssl rsa -in key.pem -out server.key 
```

## Create pfx file

```bash
openssl pkcs12 -export -out domain.name.pfx -inkey domain.name.key -in domain.name.crt

# or
openssl pkcs12 -export -in linux_cert+ca.pem -inkey privateky.key -out output.pfx

# Root CA and intermediate CA
openssl pkcs12 -export -out domain.name.pfx -inkey domain.name.key -in domain.name.crt -in intermediate.crt -in rootca.crt

# bundle
cat domain.name.crt | tee -a domain.name.bundled.crt
cat intermediate.crt | tee -a domain.name.bundled.crt
cat rootca.crt | tee -a domain.name.bundled.crt
openssl pkcs12 -export -out domain.name.pfx \
  -inkey domain.name.key \
  -in domain.name.bundled.crt
```

## multiple SAN and Extended Key Usage

```bash
# Generate the key:
openssl genrsa -out key.pem 2048
```

```conf
# config.cnf
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
   
[req_distinguished_name]
countryName = Country Name (2 letter code)
countryName_default = BE
stateOrProvinceName             = State or Province Name (full name)
stateOrProvinceName_default     = Brussels
localityName = Locality Name (eg, city)
localityName_default = Brussels
organizationalUnitName = Organizational Unit Name (eg, section)
commonName = Common Name (eg, YOUR name)
commonName_max = 64
emailAddress = Email Address
emailAddress_max = 40
    
[v3_req] 
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
    
[alt_names]
DNS.1   = san.domain1.com
DNS.2   = san.domain2.com
```

```bash
# Create the CSR:
openssl req -new -key key.pem -out cisco_fw.csr -config cisco_fw_csr_config.cnf

# If you need to check the CSR content:
openssl req -in cisco_fw.csr -noout -text
```

## Test Cipher

```bash
sudo openssl speed -evp aes-256-cbc
```

## Read CRL

```bash
openssl crl -in crl.pem -inform DER -text -noout
```

## Installing a root/CA Certificate

Given a CA certificate file foo.crt, follow these steps to install it on Ubuntu:

```bash
# Create a directory for extra CA certificates in /usr/share/ca-certificates:
sudo mkdir /usr/share/ca-certificates/extra

# Copy the CA .crt file to this directory:
sudo cp foo.crt /usr/share/ca-certificates/extra/foo.crt

# Let Ubuntu add the .crt file's path relative to /usr/share/ca-certificates to /etc/ca-certificates.conf:
sudo dpkg-reconfigure ca-certificates

# In case of a .pem file on Ubuntu, it must first be converted to a .crt file:
openssl x509 -in foo.pem -inform PEM -out foo.crt

# OR

# First, copy your CA to dir /usr/local/share/ca-certificates/
sudo cp foo.crt /usr/local/share/ca-certificates/foo.crt
 
# then, update CA store
sudo update-ca-certificates
```

## Decode / Encode

```bash
# To decode from Base64:
openssl base64 -d -in <infile> -out <outfile>
 
# Conversely, to encode to Base64:
openssl base64 -in <infile> -out <outfile>
```

## Basic info Certificates and Encodings

At its core an X.509 certificate is a digital document that has been encoded and/or digitally signed according to RFC 5280.

In fact, the term X.509 certificate usually refers to the IETF’s PKIX Certificate and CRL Profile of the X.509 v3 certificate standard, as specified in RFC 5280, commonly referred to as PKIX for Public Key Infrastructure (X.509).

X509 File Extensions
The first thing we have to understand is what each type of file extension is.   There is a lot of confusion about what DER, PEM, CRT, and CER are and many have incorrectly said that they are all interchangeable.  While in certain cases some can be interchanged the best practice is to identify how your certificate is encoded and then label it correctly.  Correctly labeled certificates will be much easier to manipulat

Encodings (also used as extensions)

- DER = The DER extension is used for binary DER encoded certificates. These files may also bear the CER or the CRT extension.   Proper English usage would be “I have a DER encoded certificate” not “I have a DER certificate”.
- PEM = The PEM extension is used for different types of X.509v3 files which contain ASCII (Base64) armored data prefixed with a “—– BEGIN …” line.
Common Extensions
- CRT = The CRT extension is used for certificates. The certificates may be encoded as binary DER or as ASCII PEM. The CER and CRT extensions are nearly synonymous.  Most common among *nix systems
- CER = alternate form of .crt (Microsoft Convention) You can use MS to convert .crt to .cer (.both DER encoded .cer, or base64[PEM] encoded .cer)  The .cer file extension is also recognized by IE as a command to run a MS cryptoAPI command (specifically rundll32.exe cryptext.dll,CryptExtOpenCER) which displays a dialogue for importing and/or viewing certificate contents.
- KEY = The KEY extension is used both for public and private PKCS#8 keys. The keys may be encoded as binary DER or as ASCII PEM.
The only time CRT and CER can safely be interchanged is when the encoding type can be identical.  (ie  PEM encoded CRT = PEM encoded CER)

## View certificate

```bash
# PEM
openssl x509 -in cert.pem -text -noout
openssl x509 -in cert.cer -text -noout
openssl x509 -in cert.crt -text -noout

# DER
openssl x509 -in certificate.der -inform der -text -noout
```

## Transformc ertificate

```bash
# PEM to DER
openssl x509 -in cert.crt -outform der -out cert.der

# DER to PEM
openssl x509 -in cert.crt -inform der -outform pem -out cert.pem

# Other examples

# Convert x509 to PEM
openssl x509 -in certificatename.cer -outform PEM -out certificatename.pem

# Convert PEM to DER
openssl x509 -outform der -in certificatename.pem -out certificatename.der

# Convert DER to PEM
openssl x509 -inform der -in certificatename.der -out certificatename.pem

# Convert PEM to P7B
# Note: The PKCS#7 or P7B format is stored in Base64 ASCII format and has a file extension of .p7b or .p7c.
# A P7B file only contains certificates and chain certificates (Intermediate CAs), not the private key. The most common platforms that support P7B files are Microsoft Windows and Java Tomcat.
openssl crl2pkcs7 -nocrl -certfile certificatename.pem -out certificatename.p7b -certfile CACert.cer

# Convert PKCS7 to PEM
openssl pkcs7 -print_certs -in certificatename.p7b -out certificatename.pem

# Convert pfx to PEM
# Note: The PKCS#12 or PFX format is a binary format for storing the server certificate, intermediate certificates, and the private key in one encryptable file. PFX files usually have extensions such as .pfx and .p12. PFX files are typically used on Windows machines to import and export certificates and private keys.
openssl pkcs12 -in certificatename.pfx -out certificatename.pem

# Convert PFX to PKCS#8
# Note: This requires 2 commands
 
# STEP 1: Convert PFX to PEM
openssl pkcs12 -in certificatename.pfx -nocerts -nodes -out certificatename.pem

# STEP 2: Convert PEM to PKCS8
openSSL pkcs8 -in certificatename.pem -topk8 -nocrypt -out certificatename.pk8

# Convert P7B to PFX
# Note: This requires 2 commands
 
# STEP 1: Convert P7B to CER
openssl pkcs7 -print_certs -in certificatename.p7b -out certificatename.cer

# STEP 2: Convert CER and Private Key to PFX
openssl pkcs12 -export -in certificatename.cer -inkey privateKey.key -out certificatename.pfx -certfile  cacert.ce

## Other
#First, extract the certificate:
openssl pkcs12 -clcerts -nokeys -in "YourPKCSFile" -out certificate.crt -password pass:PASSWORD -passin pass:PASSWORD

# Second, the CA key:
openssl pkcs12 -cacerts -nokeys -in "YourPKCSFile" -out ca-cert.ca -password pass:PASSWORD -passin pass:PASSWORD

# Now, the private key:
openssl pkcs12 -nocerts -in "YourPKCSFile" -out private.key -password pass:PASSWORD -passin pass:PASSWORD -passout pass:TemporaryPassword

# Remove now the passphrase:
openssl rsa -in private.key -out "NewKeyFile.key" -passin pass:TemporaryPassword

Put things together for the new PKCS-File:
cat "NewKeyFile.key" > PEM.pem
cat "certificate.crt" >> PEM.pem
cat "ca-cert.ca" >> PEM.pem

# And create the new file:
openssl pkcs12 -export -nodes -CAfile ca-cert.ca -in PEM.pem -out "NewPKCSWithoutPassphraseFile"
# Now you have a new PKCS12 key file without passphrase on the private key part.
```

## Reference links

- [example.cnf](https://www.phcomp.co.uk/Tutorials/Web-Technologies/example.cnf.txt)
- [openssl.cnf github](https://github.com/openssl/openssl/blob/master/apps/openssl.cnf)
- [Understanding and generating OpenSSL.cnf files](https://www.phcomp.co.uk/Tutorials/Web-Technologies/Understanding-and-generating-OpenSSL.cnf-files.html)
- [How to create .pfx file from certificate and private key?](https://stackoverflow.com/questions/6307886/how-to-create-pfx-file-from-certificate-and-private-key)
- [How to create an PFX file](https://www.sslmarket.com/ssl/how-to-create-an-pfx-file)
- [OpenSSL CSR using multiple SAN, and Extended Key Usage](https://stackoverflow.com/questions/33781051/openssl-csr-using-multiple-san-and-extended-key-usage)
- [How to add extended key usage string when generating a self-signed certificate using openssl](https://serverfault.com/questions/571910/how-to-add-extended-key-usage-string-when-generating-a-self-signed-certificate-u)
- [OpenSSL Cookbook](https://www.feistyduck.com/library/openssl-cookbook/online/)
- [Checking CRL Revocation](https://www.feistyduck.com/library/openssl-cookbook/online/testing-with-openssl/checking-crl-revocation.html)
- [OpenSSL: Manually verify a certificate against a CRL](https://raymii.org/s/articles/OpenSSL_manually_verify_a_certificate_against_a_CRL.html)
- [openssl CLI - verify CRL of an entire certification chain](https://stackoverflow.com/questions/51970569/openssl-cli-verify-crl-of-an-entire-certification-chain)
- [Using openssl to get the certificate from a server](https://stackoverflow.com/questions/7885785/using-openssl-to-get-the-certificate-from-a-server)
