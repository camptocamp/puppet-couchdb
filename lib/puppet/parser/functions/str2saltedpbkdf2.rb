module Puppet::Parser::Functions
  newfunction(:str2saltedpbkdf2, :type => :rvalue, :doc => <<-EOS
*Convert String to Salted PBKDF2 Hash*

This converts a string to a salted pbkdf2-HMAC password hash. Given a string
you will get a pbkdf2 password hash to use as a password for CouchDB.
    EOS
  ) do |args|
    require 'openssl'

   raise(Puppet::ParseError, "str2saltedpbkdf2: Wrong number of arguments " +
      "passed (#{args.size} but we require 4)") if args.size != 4
    password = args[0]
    salt = args[1]
    key_length = args[2]
    iterations = args[3]

    if salt.is_a? Fixnum
      salt = OpenSSL::Random.random_bytes(salt.to_i).unpack('H*')[0]
    elsif not salt.is_a? String
      raise(Puppet::ParseError, "str2saltedpbkdf2: Second argument must " +
        "either be a string containing the salt, or a number specifying " +
        "the length of the random salt to generate.")
    end

    hash = OpenSSL::PKCS5.pbkdf2_hmac_sha1(
      password,
      salt,
      iterations.to_i,
      key_length.to_i
    ).unpack('H*')[0]
    "-pbkdf2-#{hash},#{salt},#{iterations}"
  end
end
