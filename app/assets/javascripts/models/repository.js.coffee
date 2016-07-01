class Stronglifters.Repository
  patch: (url, payload) ->
    $.ajax
      url: url,
      dataType: 'json',
      type: 'patch',
      contentType: 'application/json',
      data: JSON.stringify(payload),
      success: (data, statux, xhr) ->
        console.log("Saved: #{data}")
      error: (xhr, status, error) ->
        console.log(error)
