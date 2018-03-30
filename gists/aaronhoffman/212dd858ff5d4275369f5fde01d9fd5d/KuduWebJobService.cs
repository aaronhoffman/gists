public class KuduWebJobService
{
    private string KuduUserName { get; set; }
    private string KuduPassword { get; set; }
    private string AzureWebsiteName { get; set; }

    public KuduWebJobService()
    {
        this.KuduUserName = "";
        this.KuduPassword = "";
        this.AzureWebsiteName = "";
    }

    public List<string> GetWebJobStatuses()
    {
        var result = new List<string>();
        var client = this.CreateWebClient();
        var allJobsJson = client.DownloadString($"https://{this.AzureWebsiteName}.scm.azurewebsites.net/api/webjobs");

        dynamic allJobs = JsonConvert.DeserializeObject(allJobsJson);

        foreach (var job in allJobs)
        {
            var name = job["name"] ?? "[unknown]";
            var status = job["status"] ?? "[triggeredWebJob]";
            result.Add($"name:{name}; status:{status}");
        }

        return result;
    }

    public string StartWebJob(string webJobName)
    {
        var client = this.CreateWebClient();

        var response = client.UploadString($"https://{this.AzureWebsiteName}.scm.azurewebsites.net/api/continuouswebjobs/{webJobName}/start", "POST", "");

        return response;
    }

    public string StopWebJob(string webJobName)
    {
        var client = this.CreateWebClient();

        var response = client.UploadString($"https://{this.AzureWebsiteName}.scm.azurewebsites.net/api/continuouswebjobs/{webJobName}/stop", "POST", "");

        return response;
    }

    private WebClient CreateWebClient()
    {
        var client = new WebClient();
        var base64Auth = Convert.ToBase64String(Encoding.Default.GetBytes($"{this.KuduUserName}:{this.KuduPassword}"));
        client.Headers.Add(HttpRequestHeader.Authorization, $"Basic {base64Auth}");

        return client;
    }
}