CREATE TABLE meetings (
    conversation_id             TEXT PRIMARY KEY,
    google_calendar_event_id    TEXT UNIQUE,
    customer_name               TEXT,
    email                       TEXT UNIQUE,
    scheduled_date              TIMESTAMP,
    interest_level              TEXT NOT NULL DEFAULT 'limpo',
    urgency_level               TEXT NOT NULL DEFAULT 'limpo',
    office_size                 INTEGER,
    main_need                   TEXT,
    conversation_summary        TEXT,
    current_stage               INTEGER NOT NULL DEFAULT 1,
    meeting_status              TEXT NOT NULL DEFAULT 'agendada',
    created_at                  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT interest_level_check
        CHECK (interest_level IN ('baixo', 'médio', 'alto', 'limpo')),

    CONSTRAINT urgency_level_check
        CHECK (urgency_level IN ('baixa', 'média', 'alta', 'limpo')),

    CONSTRAINT current_stage_check
        CHECK (current_stage BETWEEN 1 AND 6),

    CONSTRAINT meeting_status_check
        CHECK (meeting_status IN ('agendada', 'reagendada', 'aconteceu', 'cancelada', 'nao_compareceu', 'limpo'))
);