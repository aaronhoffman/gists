public class SpotifyApiController
{
  //see https://developer.spotify.com/web-api/authorization-guide/#client_credentials_flow
  public void GetClientCredentialsAuthToken()
  {
    var spotifyClient = "";
    var spotifySecret = "";
    
    var webClient = new WebClient();
    
    var postparams = new NameValueCollection();
    postparams.Add("grant_type", "client_credentials");
    
    var authHeader = Convert.ToBase64String(Encoding.Default.GetBytes($"{spotifyClient}:{spotifySecret}"));
    webClient.Headers.Add(HttpRequestHeader.Authorization, "Basic " + authHeader);
    
    var tokenResponse = webClient.UploadValues("https://accounts.spotify.com/api/token", postparams);
    
    var textResponse = Encoding.UTF8.GetString(tokenResponse);
  }
}