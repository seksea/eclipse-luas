local response = web.get("https://example.com", "/")

print(response.status .. "\n\n" .. response.body)