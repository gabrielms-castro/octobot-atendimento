CREATE TABLE meetings (
    conversation_id TEXT PRIMARY KEY,
    google_calendar_event_id TEXT UNIQUE,
    customer_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    scheduled_date TIMESTAMP NOT NULL,
    conversation_summary TEXT NOT NULL,
    interest_level TEXT NOT NULL,
    meeting_status TEXT NOT NULL DEFAULT 'agendada',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT interest_level_check
        CHECK (interest_level IN ('baixo', 'medio', 'alto')),

    CONSTRAINT status_check
        CHECK (meeting_status IN ('agendada', 'reagendada', 'aconteceu', 'cancelada', 'nao_compareceu'))
);