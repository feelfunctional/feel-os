import json
import urllib.request
import urllib.error

URL = "https://qloxcjohrqzrbkjmqult.supabase.co/rest/v1/cafeterias"
KEY = "sb_publishable_sHLQOYECRwLN3Jwz8YvH5g_mov7NXxv"

# Leer JSON
with open("cafeterias.js-fdd082f2.json", "r", encoding="utf-8") as f:
    cafeterias = json.load(f)

# Transformar datos
transformed = []
for item in cafeterias:
    transformed.append({
        "title": item.get("title"),
        "phone": item.get("phone"),
        "street": item.get("street"),
        "city": item.get("city"),
        "state": item.get("state"),
        "country_code": item.get("countryCode"),
        "total_score": item.get("totalScore"),
        "reviews_count": item.get("reviewsCount"),
        "categories": item.get("categories", []),
        "category_name": item.get("categoryName"),
        "url": item.get("url"),
        "website": item.get("website"),
        "contactado": False,
        "estado": "pendiente"
    })

print(f"📍 Importando {len(transformed)} cafeterías...")

# Insertar
data = json.dumps(transformed).encode('utf-8')
req = urllib.request.Request(
    URL,
    data=data,
    headers={
        "apikey": KEY,
        "Authorization": f"Bearer {KEY}",
        "Content-Type": "application/json"
    },
    method="POST"
)

try:
    with urllib.request.urlopen(req) as response:
        result = response.read().decode('utf-8')
        print(f"✅ Importación completada!")
        print(f"Respuesta: {result[:200]}")
except urllib.error.HTTPError as e:
    print(f"❌ Error: {e.code}")
    print(e.read().decode('utf-8'))
