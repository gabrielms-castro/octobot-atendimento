-- migrate:up
CREATE TABLE IF NOT EXISTS meetings (
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	session_id TEXT NOT NULL,
	lead_name TEXT NOT NULL,
	phone_number TEXT NOT NULL,
	email TEXT NOT NULL,

	google_event_id TEXT,
	meet_status TEXT,
	meet_time TIMESTAMPTZ,
	meet_link TEXT,

	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- migrate:down
DROP TABLE IF EXISTS meetings;