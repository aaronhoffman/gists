convert(char(48), HASHBYTES('sha1', @HashInput), 2)
convert(char(64), HASHBYTES('sha2_256', @HashInput), 2)