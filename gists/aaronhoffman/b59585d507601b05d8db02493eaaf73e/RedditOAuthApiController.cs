public ActionResult StartOAuth()
{
  var redditOAuthAuthorizeUri = "https://www.reddit.com/api/v1/authorize";
  var redditOAuthRedirectUri = "https://localhost:44399/RedditRedirectUri"; // your redirect uri
  var redditOAuthScopes = ""; // ex: "identity,history" scope param https://github.com/reddit/reddit/wiki/OAuth2#authorization
  var redditClientId = ""; // from app: https://www.reddit.com/prefs/apps
  var oauthState = Guid.NewGuid(); // used to uniquely identify this request
  
  // todo: store oauthState somewhere...
  
  var authUri = $"{redditOAuthAuthorizeUri}?client_id={redditClientId}&response_type=code&state={oauthState}&redirect_uri={redditOAuthRedirectUri}&duration=temporary&scope={redditOAuthScopes}";

  return Redirect(authUri);
}

public ActionResult RedirectUri(string error, string code, string state)
{
  // todo: check error param...

  // todo: retrieve oauthState info...

  var redditOAuthAccessTokenUri = "https://www.reddit.com/api/v1/access_token";
  var redditOAuthRedirectUri = "https://localhost:44399/RedditRedirectUri"; // your redirect uri
  var redditClientId = ""; // from app: https://www.reddit.com/prefs/apps
  var redditSecret = ""; // from app: https://www.reddit.com/prefs/apps

  // make POST request for accessToken

  var client = new WebClient();

  var basicAuthHeader = Convert.ToBase64String(Encoding.Default.GetBytes(redditClientId + ":" + redditSecret));
  client.Headers[HttpRequestHeader.Authorization] = "Basic " + basicAuthHeader;

  var postData = new NameValueCollection();
  postData.Add("grant_type", "authorization_code");
  postData.Add("code", code);
  postData.Add("redirect_uri", redditOAuthRedirectUri);

  var responseBytes = client.UploadValues(redditOAuthAccessTokenUri, "POST", postData);
  var responseString = Encoding.Default.GetString(responseBytes);
  var response = JsonConvert.DeserializeObject<dynamic>(responseString);

  var accessToken = response.access_token.ToString();

  // todo: store values from response...

  return View();
}

private void GetSomeData(string accessToken)
{
  var redditOAuthApiBaseUri = "https://oauth.reddit.com";
  var after = ""; // used to page through results
  var userName = ""; // set username here for this example
  
  do
  {
    var client = new WebClient();
    client.Headers[HttpRequestHeader.Authorization] = "bearer " + accessToken;
    client.Headers[HttpRequestHeader.UserAgent] = "web:myapp:v1.0.0 (by /u/username)"; // reddit api requires User-Agent header https://github.com/reddit/reddit/wiki/API#rules

    // api methods: https://www.reddit.com/dev/api/oauth/
    var submittedUri = redditOAuthApiBaseUri + $"/user/{userName}/submitted?sort=new&t=all&limit=100&raw_json=1&after={after}";

    var submittedResultString = client.DownloadString(submittedUri);
    var submittedResult = JsonConvert.DeserializeObject<dynamic>(submittedResultString);

    // capture after here for paging results, when empty, there are no additional results
    after = submittedResult.data.after.ToString();

    foreach (var item in submittedResult.data.children)
    {
      // todo
    }

  } while (!String.IsNullOrWhiteSpace(after));
}