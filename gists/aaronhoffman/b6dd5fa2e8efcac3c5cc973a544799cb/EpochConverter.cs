private static readonly DateTime _epoch = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);
public DateTime EpochSecondsToDateTime(int secondsSinceEpoch)
{
    return _epoch.AddSeconds(secondsSinceEpoch);
}