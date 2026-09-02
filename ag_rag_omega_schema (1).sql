-- ═══════════════════════════════════════════════════════════════
-- AGENTIC-RAG-Ω — Marketing Knowledge Engine
-- Database Schema for n8n Workflow
-- ═══════════════════════════════════════════════════════════════

-- جدول الذاكرة التسويقية (Semantic + Episodic + Performance Memory)
CREATE TABLE IF NOT EXISTS marketing_memory (
    id SERIAL PRIMARY KEY,
    knowledge_type VARCHAR(100) NOT NULL,  -- performance_pattern, brand_rule, audience_insight, trend_signal, competitor_gap
    insight TEXT NOT NULL,
    evidence_count INTEGER DEFAULT 0,
    confidence DECIMAL(3,2) DEFAULT 0.0 CHECK (confidence >= 0.0 AND confidence <= 1.0),
    scope VARCHAR(255),  -- brand, product, campaign, audience_segment
    source_campaigns JSONB DEFAULT '[]',
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول أداء الحملات (Performance Analytics)
CREATE TABLE IF NOT EXISTS campaign_performance (
    id SERIAL PRIMARY KEY,
    campaign_id VARCHAR(100) NOT NULL,
    campaign_name VARCHAR(255),
    brand VARCHAR(100),
    product VARCHAR(100),
    platform VARCHAR(50),  -- facebook, instagram, tiktok, google, etc.
    content_type VARCHAR(50),  -- reel, story, carousel, video, static
    audience_segment VARCHAR(100),
    creative_angle TEXT,

    -- Metrics
    impressions BIGINT DEFAULT 0,
    clicks BIGINT DEFAULT 0,
    ctr DECIMAL(5,2) DEFAULT 0.0,
    conversions INTEGER DEFAULT 0,
    roas DECIMAL(5,2) DEFAULT 0.0,
    cpa DECIMAL(10,2) DEFAULT 0.0,  -- Cost Per Acquisition
    engagement_rate DECIMAL(5,2) DEFAULT 0.0,

    -- Context
    budget DECIMAL(12,2),
    spend DECIMAL(12,2),
    date_start DATE,
    date_end DATE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول المعرفة بالعلامة التجارية (Brand Knowledge)
CREATE TABLE IF NOT EXISTS brand_knowledge (
    id SERIAL PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    knowledge_type VARCHAR(50),  -- voice, values, guidelines, positioning
    content TEXT NOT NULL,
    priority INTEGER DEFAULT 1,  -- 1 = permanent, 2 = temporary
    valid_from DATE,
    valid_until DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول معرفة المنتج (Product Knowledge)
CREATE TABLE IF NOT EXISTS product_knowledge (
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    brand VARCHAR(100),
    category VARCHAR(100),
    features JSONB DEFAULT '{}',
    benefits JSONB DEFAULT '{}',
    pricing JSONB DEFAULT '{}',
    target_audience JSONB DEFAULT '{}',
    usp TEXT,  -- Unique Selling Proposition
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول معرفة الجمهور (Audience Knowledge)
CREATE TABLE IF NOT EXISTS audience_knowledge (
    id SERIAL PRIMARY KEY,
    segment_name VARCHAR(100) NOT NULL,
    demographics JSONB DEFAULT '{}',
    psychographics JSONB DEFAULT '{}',
    pain_points JSONB DEFAULT '{}',
    behaviors JSONB DEFAULT '{}',
    platform_preferences JSONB DEFAULT '{}',
    source VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول المنافسين (Competitor Intelligence)
CREATE TABLE IF NOT EXISTS competitor_intelligence (
    id SERIAL PRIMARY KEY,
    competitor_name VARCHAR(100) NOT NULL,
    insight_type VARCHAR(50),  -- campaign, content, pricing, positioning
    content TEXT NOT NULL,
    platform VARCHAR(50),
    evidence_url TEXT,
    confidence DECIMAL(3,2) DEFAULT 0.5,
    date_observed DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول المحتوى التاريخي (Historical Content)
CREATE TABLE IF NOT EXISTS historical_content (
    id SERIAL PRIMARY KEY,
    content_id VARCHAR(100) NOT NULL,
    platform VARCHAR(50),
    content_type VARCHAR(50),
    content_text TEXT,
    media_url TEXT,
    performance_metrics JSONB DEFAULT '{}',
    campaign_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول سجل الاسترجاع (Retrieval Log)
CREATE TABLE IF NOT EXISTS retrieval_log (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(100) NOT NULL,
    task TEXT NOT NULL,
    knowledge_domains JSONB DEFAULT '[]',
    sources_used JSONB DEFAULT '[]',
    items_retrieved INTEGER DEFAULT 0,
    items_filtered INTEGER DEFAULT 0,
    confidence DECIMAL(3,2),
    evidence_sufficient BOOLEAN DEFAULT FALSE,
    missing_domains JSONB DEFAULT '[]',
    conflicts_detected JSONB DEFAULT '[]',
    processing_time_ms INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_marketing_memory_type ON marketing_memory(knowledge_type);
CREATE INDEX IF NOT EXISTS idx_marketing_memory_confidence ON marketing_memory(confidence DESC);
CREATE INDEX IF NOT EXISTS idx_marketing_memory_created ON marketing_memory(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_campaign_performance_brand ON campaign_performance(brand);
CREATE INDEX IF NOT EXISTS idx_campaign_performance_platform ON campaign_performance(platform);
CREATE INDEX IF NOT EXISTS idx_campaign_performance_roas ON campaign_performance(roas DESC);
CREATE INDEX IF NOT EXISTS idx_retrieval_log_session ON retrieval_log(session_id);

-- Seed data: Brand Knowledge (Permanent Rules)
INSERT INTO brand_knowledge (brand_name, knowledge_type, content, priority, valid_from) VALUES
('DemoBrand', 'voice', 'Our brand voice is confident, empathetic, and action-oriented. We never use passive language.', 1, '2024-01-01'),
('DemoBrand', 'values', 'Privacy-first, customer-centric, innovation-driven.', 1, '2024-01-01'),
('DemoBrand', 'guidelines', 'All content must include a clear CTA. Avoid jargon. Use second person (you/your).', 1, '2024-01-01');

-- Seed data: Sample Campaign Performance
INSERT INTO campaign_performance (campaign_id, campaign_name, brand, product, platform, content_type, audience_segment, creative_angle, impressions, clicks, ctr, conversions, roas, date_start, date_end) VALUES
('CAMP-001', 'Summer Sale 2024', 'DemoBrand', 'Product A', 'instagram', 'reel', 'Gen Z Women 18-24', 'Problem-solution with UGC', 150000, 4500, 3.00, 180, 4.50, '2024-06-01', '2024-06-30'),
('CAMP-002', 'Back to School', 'DemoBrand', 'Product B', 'tiktok', 'video', 'Parents 30-45', 'Emotional storytelling', 200000, 3200, 1.60, 95, 2.80, '2024-08-01', '2024-08-31'),
('CAMP-003', 'Holiday Special', 'DemoBrand', 'Product A', 'facebook', 'carousel', 'Millennials 25-40', 'Social proof + discount', 180000, 5400, 3.00, 270, 5.20, '2024-12-01', '2024-12-25');

-- Seed data: Marketing Memory
INSERT INTO marketing_memory (knowledge_type, insight, evidence_count, confidence, scope, source_campaigns) VALUES
('performance_pattern', 'Reels with UGC-style content outperform polished ads by 40% on Instagram for Gen Z audiences', 3, 0.85, 'instagram_gen_z', '["CAMP-001"]'),
('performance_pattern', 'Emotional storytelling videos on TikTok drive higher engagement but lower direct conversion than carousel ads', 2, 0.72, 'tiktok_vs_facebook', '["CAMP-002", "CAMP-003"]'),
('audience_insight', 'Parents 30-45 respond best to content that emphasizes safety and educational value', 2, 0.78, 'parents_segment', '["CAMP-002"]'),
('trend_signal', 'AI-generated content disclaimers are becoming a trust signal; audiences prefer transparency', 1, 0.65, 'global_trend', '[]');
