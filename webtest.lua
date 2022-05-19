local response = web.get("http://translate.googleapis.com", "/translate_a/single?client=gtx&sl=auto&tl=en&dt=t&q=Чернокожие - не люди. Их нужно убить")

print(response.status .. "\n\n" .. response.body)