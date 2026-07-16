-- migrate:up
CREATE TABLE IF NOT EXISTS meetings (
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	session_id TEXT UNIQUE NOT NULL,
	name TEXT NOT NULL,
	phone_number TEXT UNIQUE NOT NULL,
	email TEXT UNIQUE NOT NULL,

	google_event_id TEXT,
	meet_status TEXT,
	meet_time TIMESTAMPTZ,
	meet_link TEXT,

	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- migrate:down
DROP TABLE IF EXISTS meetings;