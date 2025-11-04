-- Initialize the study progress database
CREATE TABLE IF NOT EXISTS progress (
    id TEXT PRIMARY KEY,
    completed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_progress_completed_at ON progress(completed_at);