class APIConstants {
  static Map<String, String> headers = {
    'Accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'Accept-Encoding': 'gzip, deflate, br, zstd',
    'Accept-Language': 'en-US,en-IN;q=0.9,en;q=0.8',
    'Cache-Control': 'no-cache',
    'Cookie':
        'cf_clearance=N0Ho5wnUNFwGZGQ7TZqSeaMYrQBzYPxKfeKlI3GOQyo-1720424515-1.0.1.1-ovVMZEezFPWEbkVTPm9O1apeEIqnKlKagIYssls3ETTfYlfGsS1IuJgNidxD5JE4KdzIqayeQhaYFUXDEosUow',
    'Dnt': '1',
    'Pragma': 'no-cache',
    'Priority': 'u=0, i',
    'Sec-Ch-Ua':
        '"Not/A)Brand";v="8", "Chromium";v="126", "Google Chrome";v="126"',
    'Sec-Ch-Ua-Arch': 'x86',
    'Sec-Ch-Ua-Bitness': '64',
    'Sec-Ch-Ua-Full-Version': '126.0.6478.127',
    'Sec-Ch-Ua-Full-Version-List':
        '"Not/A)Brand";v="8.0.0.0", "Chromium";v="126.0.6478.127", "Google Chrome";v="126.0.6478.127"',
    'Sec-Ch-Ua-Mobile': '?0',
    'Sec-Ch-Ua-Model': '',
    'Sec-Ch-Ua-Platform': 'Windows',
    'Sec-Ch-Ua-Platform-Version': '15.0.0',
    'Sec-Fetch-Dest': 'document',
    'Sec-Fetch-Mode': 'navigate',
    'Sec-Fetch-Site': 'none',
    'Sec-Fetch-User': '?1',
    'Upgrade-Insecure-Requests': '1',
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36',
  };

  /// Returns the URL for the search API with the provided search query.
  ///
  /// Parameters:
  /// - `searchString`: The search query to be used in the API request.
  ///
  /// Returns:
  /// - A `String` representing the URL for the search API.
  static String searchUrl({String? searchString}) {
    String validString = searchString!.replaceAll(" ", "%20");
    return "https://kisskh.co/api/DramaList/Search?q=$validString";
  }

  static String dramaDetailsUrl({int? dramaID}) {
    /// Returns the URL for fetching details of a drama based on the provided drama ID.
    ///
    /// Parameters:
    ///   - `dramaID`: The ID of the drama.
    ///
    /// Returns:
    ///   A string representing the URL for fetching the drama details.
    return "https://kisskh.co/api/DramaList/Drama/$dramaID?isq=false";
  }

  /// Returns the URL for fetching subtitles of an episode based on the provided episode ID.
  ///
  /// Parameters:
  ///   - episodeID: The ID of the episode for which to fetch subtitles.
  ///
  /// Returns:
  ///   A string representing the URL for fetching subtitles.
  static String subtitleUrl({int? episodeID}) {
    return "https://kisskh.co/api/Sub/$episodeID";
  }

  /// Returns the URL for streaming an episode based on the provided episode ID.
  ///
  /// Parameters:
  ///   - episodeID: The ID of the episode to stream.
  ///
  /// Returns:
  ///   A string representing the URL for streaming the episode.
  static String streamUrl({int? episodeID}) {
    return "https://kisskh.co/api/DramaList/Episode/$episodeID.png?err=false&ts=&time=";
  }
}
