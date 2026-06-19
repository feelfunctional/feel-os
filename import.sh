#!/bin/bash

URL="https://qloxcjohrqzrbkjmqult.supabase.co/rest/v1/cafeterias"
KEY="sb_publishable_sHLQOYECRwLN3Jwz8YvH5g_mov7NXxv"
FILE="cafeterias.js-fdd082f2.json"

echo "📍 Importando cafeterías..."

# Leer JSON y transformar para inserción
cat "$FILE" | jq '.[] | {
  title: .title,
  phone: .phone,
  street: .street,
  city: .city,
  state: .state,
  country_code: .countryCode,
  total_score: .totalScore,
  reviews_count: .reviewsCount,
  categories: .categories,
  category_name: .categoryName,
  url: .url,
  website: .website,
  contactado: false,
  estado: "pendiente"
}' | jq -s '.' | curl -X POST "$URL" \
  -H "apikey: $KEY" \
  -H "Authorization: Bearer $KEY" \
  -H "Content-Type: application/json" \
  -d @-

echo ""
echo "✅ ¡Importación completada!"
