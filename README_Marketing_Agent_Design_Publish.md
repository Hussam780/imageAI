# 🧠 AGENTIC-RAG-Ω — Marketing Agent (Design + Publish)

## نظرة عامة
وكيل تسويقي ذكي على **n8n** يقوم بـ **6 مهام تلقائية**:

```
PLAN → RETRIEVE → SYNTHESIZE → GENERATE IMAGE → GENERATE VIDEO PROMPT → PUBLISH → MEMORY
```

| المرحلة | الوظيفة |
|---------|---------|
| 1. Retrieval Planning | يحدد المهمة والجمهور والمنصة |
| 2. Retrieve | يسترجع بيانات من الذاكرة + الأداء + قواعد العلامة |
| 3. Filter/Rerank/Grade | يُقيّم الأدلة بـ 5 معايير |
| 4. AI Synthesize | يولّف استراتيجية محتوى + caption + hashtags + prompts |
| 5. Generate Image | يُنشئ صورة بـ **DALL-E 3** |
| 6. Prepare Video | يُجهّز prompt لتوليد فيديو (Runway/Pika) |
| 7. Publish | ينشر تلقائياً على **Instagram / Facebook / LinkedIn / X / TikTok** |
| 8. Save Memory | يحفظ التجربة للاستخدام المستقبلي |

---

## 📦 الملفات

| الملف | الوصف |
|-------|-------|
| `AGENTIC_RAG_OMEGA_marketing_agent_design_publish.json` | **سير العمل الكامل** — 23 node |
| `ag_rag_omega_schema.sql` | مخطط قاعدة البيانات |

---

## 🚀 الإعداد

### 1. قاعدة البيانات
```bash
psql -U postgres -c "CREATE DATABASE marketing_engine;"
psql -U postgres -d marketing_engine -f ag_rag_omega_schema.sql
```

### 2. استيراد Workflow
- n8n → **Workflows → Import from File**
- اختر `AGENTIC_RAG_OMEGA_marketing_agent_design_publish.json`

### 3. الـ Credentials المطلوبة

| Credential | النوع | الاستخدام |
|------------|-------|-----------|
| `OpenAI API` | `openAiApi` | توليد الاستراتيجية + صور DALL-E |
| `PostgreSQL` | `postgres` | الذاكرة + بيانات الأداء |
| `Meta Access Token` | `httpHeaderAuth` | نشر Instagram + Facebook |
| `LinkedIn Access Token` | `httpHeaderAuth` | نشر LinkedIn |
| `X/Twitter OAuth2` | `oAuth2` | نشر X/Twitter |

### 4. متغيرات البيئة (Environment Variables)

في n8n → **Settings → Variables**:

```
INSTAGRAM_BUSINESS_ACCOUNT_ID = your_ig_business_account_id
FACEBOOK_PAGE_ID = your_fb_page_id
LINKEDIN_PERSON_URN = your_linkedin_person_urn
```

---

## 📡 استخدام الوكيل

### طلب POST
```bash
curl -X POST https://YOUR_N8N_URL/webhook/marketing-agent   -H "Content-Type: application/json"   -d '{
    "task": "أنشئ حملة صيفية لمنتج عصير طبيعي",
    "brand": "JuicyCo",
    "product": "عصير برتقال طبيعي",
    "audience": "شباب 18-30 يهتمون بالصحة",
    "platform": "instagram",
    "contentType": "image",
    "tone": "fun",
    "publish": true,
    "sessionId": "sess-001"
  }'
```

### الرد
```json
{
  "success": true,
  "session_id": "sess-001",
  "content_brief": {
    "strategy": "حملة صيفية تركز على الطاقة والانتعاش...",
    "visual_concept": "صورة برتقال طازج مع قطرات ماء وخلفية شاطئ صيفي...",
    "caption": "☀️ صيفك يبدأ ببرتقالة! 🍊 عصير 100% طبيعي بدون سكر مضاف...",
    "hashtags": ["#عصير_طبيعي", "#صيف_2026", "#صحتي", "#طاقة", "#برتقال"],
    "cta": "اطلب الآن واستمتع بالانتعاش!"
  },
  "generated_assets": {
    "image_url": "https://oaidalleapiprodscus.blob.core.windows.net/...",
    "video_prompt": "A cinematic shot of fresh oranges being squeezed...",
    "video_status": "pending_external_api"
  },
  "publish_status": {
    "platform": "instagram",
    "published": true,
    "post_id": "179xxxxx"
  },
  "confidence": 0.88
}
```

---

## 🎨 توليد المحتوى البصري

### الصور (DALL-E 3)
الوكيل يولّف prompt تفصيلي ويُرسله تلقائياً إلى DALL-E 3.

### الفيديوهات
توليد الفيديو يتطلب API خارجية. الوكيل يُجهّز الـ prompt ويمكنك:
1. استخدام **Runway ML** (`https://api.runwayml.com`)
2. استخدام **Pika Labs**
3. استخدام **Kling AI**
4. رفع الفيديو يدوياً باستخدام الـ prompt المُجهّز

---

## 📱 المنصات المدعومة

| المنصة | النشر | ملاحظات |
|--------|-------|---------|
| **Instagram** | ✅ تلقائي | يتطلب Meta Business Account + Access Token |
| **Facebook** | ✅ تلقائي | يتطلب Facebook Page + Access Token |
| **LinkedIn** | ✅ تلقائي | يتطلب LinkedIn Developer App + Access Token |
| **X/Twitter** | ✅ تلقائي | يتطلب OAuth2 App |
| **TikTok** | ⚠️ Draft | يتطلب Creator Portal API (يُجهّز المحتوى للرفع اليدوي) |

---

## 🔐 الحصول على API Keys

### Meta (Instagram + Facebook)
1. اذهب إلى [Meta for Developers](https://developers.facebook.com)
2. أنشئ App → اختر "Business"
3. احصل على **Access Token** (مع صلاحيات `instagram_basic`, `instagram_content_publish`, `pages_manage_posts`)
4. احصل على **Instagram Business Account ID** من Facebook Business Manager

### LinkedIn
1. اذهب إلى [LinkedIn Developers](https://developer.linkedin.com)
2. أنشئ App → اختر "Share on LinkedIn"
3. احصل على **Access Token** (مع صلاحيات `w_member_social`)
4. احصل على **Person URN** من `https://api.linkedin.com/v2/me`

### X/Twitter
1. اذهب إلى [Twitter Developer Portal](https://developer.twitter.com)
2. أنشئ App → اختر "Elevated"
3. احصل على **OAuth 2.0 Client ID + Secret**
4. في n8n → أنشئ credential من نوع `OAuth2 API`

---

## 🏗️ هيكل سير العمل

```
┌─────────────────┐
│ Webhook Trigger │
└────────┬────────┘
         ▼
┌─────────────────────┐
│ 1. Retrieval Plan   │
└────────┬────────────┘
         ▼
    ┌────┴────┬────────┐
    ▼         ▼        ▼
┌────────┐ ┌────────┐ ┌────────────┐
│ Memory │ │Performance│ │ Brand Rules│
└────┬───┘ └───┬────┘ └──────┬─────┘
     └─────────┴─────────────┘
                 ▼
    ┌─────────────────────────┐
    │ 3. Filter/Rerank/Grade  │
    └────────────┬────────────┘
                 ▼
    ┌─────────────────────────┐
    │ 4. Prepare Synthesis    │
    └────────────┬────────────┘
                 ▼
    ┌─────────────────────────┐
    │ 5. AI Strategy (GPT-4o) │
    └────────────┬────────────┘
                 ▼
    ┌─────────────────────────┐
    │ 6. Parse Content Brief  │
    └────────────┬────────────┘
       ┌────────┴────────┐
       ▼                 ▼
┌──────────────┐  ┌──────────────┐
│ 7a. DALL-E   │  │ 7b. Video  │
│   Image      │  │   Prompt   │
└──────┬───────┘  └──────┬─────┘
       └────────┬────────┘
                ▼
    ┌─────────────────────────┐
    │ 8. Route Publisher      │
    └────────────┬────────────┘
       ┌────┬────┬────┬────┐
       ▼    ▼    ▼    ▼    ▼
    ┌────┐┌────┐┌────┐┌────┐┌────┐
    │ IG ││ FB ││ LI ││ X  ││ TT │
    └─┬──┘└─┬──┘└─┬──┘└─┬──┘└─┬──┘
      └─────┴─────┴─────┴─────┘
                ▼
    ┌─────────────────────────┐
    │ 10. Save to Memory      │
    └────────────┬────────────┘
                 ▼
    ┌─────────────────────────┐
    │ 11. Structure Output    │
    └────────────┬────────────┘
                 ▼
    ┌─────────────────────────┐
    │ 12. Respond to Webhook  │
    └─────────────────────────┘
```

---

## ⚡ أمثلة استخدام

### 1. منشور إنستغرام + صورة
```json
{
  "task": "أنشئ منشور ترحيبي لمتجر جديد",
  "platform": "instagram",
  "contentType": "image",
  "tone": "friendly",
  "publish": true
}
```

### 2. منشور لينكدإن احترافي
```json
{
  "task": "أنشئ منشور عن إطلاق منتج تقني جديد",
  "platform": "linkedin",
  "contentType": "image",
  "tone": "professional",
  "publish": true
}
```

### 3. محتوى فقط (بدون نشر)
```json
{
  "task": "صمم محتوى لحملة العيد",
  "platform": "instagram",
  "contentType": "image",
  "publish": false
}
```

### 4. فيديو (يُجهّز prompt فقط)
```json
{
  "task": "أنشئ فيديو إعلاني لمنتج رياضي",
  "platform": "tiktok",
  "contentType": "video",
  "publish": false
}
```

---

## 🛠️ تخصيص الوكيل

### تغيير نموذج الصور
في node **"7a. Generate Image"**:
- `dall-e-3` (افتراضي) — أفضل جودة
- `dall-e-2` — أسرع وأرخص

### إضافة منصة جديدة
1. أنشئ node `HTTP Request`
2. صِلْه بـ `8. Route Publisher`
3. أضف شرط التوجيه في الكود

### تغيير حجم الصورة
في node DALL-E:
- `1024x1024` (مربع)
- `1792x1024` (واسع)
- `1024x1792` (طويل)

---

## 📊 معايير التقييم (Composite Score)

| المعيار | الوزن |
|---------|-------|
| Relevance | 30% |
| Authority | 25% |
| Freshness | 15% |
| Business Fit | 15% |
| Performance Relevance | 15% |

---

Built with 🧠 AGENTIC-RAG-Ω + 🎨 DALL-E + 📱 Social APIs + ⚡ n8n
