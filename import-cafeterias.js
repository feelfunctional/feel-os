import { createClient } from '@supabase/supabase-js';
import fs from 'fs';

const SUPABASE_URL = 'https://qloxcjohrqzrbkjmqult.supabase.co';
const SUPABASE_KEY = 'sb_publishable_sHLQOYECRwLN3Jwz8YvH5g_mov7NXxv';

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

async function importCafeterias() {
  try {
    // Leer JSON
    const rawData = fs.readFileSync('dataset_crawler-google-places_2026-06-17_08-15-42-196.json', 'utf-8');
    const cafeterias = JSON.parse(rawData);

    // Transformar datos
    const transformed = cafeterias.map(item => ({
      title: item.title,
      phone: item.phone || null,
      street: item.street || null,
      city: item.city || null,
      state: item.state || null,
      country_code: item.countryCode || null,
      total_score: item.totalScore || null,
      reviews_count: item.reviewsCount || null,
      categories: item.categories || [],
      category_name: item.categoryName || null,
      url: item.url || null,
      website: item.website || null,
      contactado: false,
      estado: 'pendiente'
    }));

    console.log(`📍 Importando ${transformed.length} cafeterías...`);

    // Insertar en lotes de 100
    for (let i = 0; i < transformed.length; i += 100) {
      const batch = transformed.slice(i, i + 100);
      const { error } = await supabase
        .from('cafeterias')
        .insert(batch);

      if (error) {
        console.error(`❌ Error en lote ${i}-${i + 100}:`, error);
      } else {
        console.log(`✅ Insertadas ${Math.min(i + 100, transformed.length)}/${transformed.length}`);
      }
    }

    console.log('✨ ¡Importación completada!');
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

importCafeterias();
