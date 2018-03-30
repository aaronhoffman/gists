public static class AesKeyGenerator
{
  public static string GenerateKey(int bitStrength)
  {
    // note: valid bit strength for aes: 128, 192, or 256 bits (16, 24, or 32 bytes)

    var random = new System.Security.Cryptography.RNGCryptoServiceProvider();
    var keyArray = new byte[bitStrength / 8];
    random.GetBytes(keyArray);
    var base64key = Convert.ToBase64String(keyArray);
    
    return base64key;
  }
}