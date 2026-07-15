-- ThreeFourThree Football Tournament Management Database
-- Complete schema supporting leagues, clubs, players, tournaments, matches, and events
-- Designed to scale with thousands of players and clubs

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- CORE REFERENCE TABLES
-- ============================================================================

-- Countries lookup table
CREATE TABLE IF NOT EXISTS countries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code VARCHAR(2) UNIQUE NOT NULL, -- ISO 3166-1 alpha-2
  name VARCHAR(100) NOT NULL,
  flag_emoji VARCHAR(10),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Positions reference table
CREATE TABLE IF NOT EXISTS positions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code VARCHAR(3) UNIQUE NOT NULL, -- GK, DEF, MID, FWD, SUB
  name VARCHAR(50) NOT NULL,
  category VARCHAR(20) NOT NULL, -- goalkeeper, defender, midfielder, forward
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- LEAGUES
-- ============================================================================

CREATE TABLE IF NOT EXISTS leagues (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(150) NOT NULL,
  country_id UUID NOT NULL REFERENCES countries(id) ON DELETE RESTRICT,
  logo_url TEXT,
  tier INT, -- 1 for top tier, 2 for second tier, etc.
  season INT NOT NULL, -- 2024, 2025, etc.
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(name, country_id, season)
);

CREATE INDEX IF NOT EXISTS idx_leagues_country_id ON leagues(country_id);
CREATE INDEX IF NOT EXISTS idx_leagues_season ON leagues(season);

-- ============================================================================
-- CLUBS
-- ============================================================================

CREATE TABLE IF NOT EXISTS clubs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(150) NOT NULL,
  country_id UUID NOT NULL REFERENCES countries(id) ON DELETE RESTRICT,
  logo_url TEXT,
  stadium_name VARCHAR(150),
  manager_name VARCHAR(100),
  founded_year INT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(name, country_id)
);

CREATE INDEX IF NOT EXISTS idx_clubs_country_id ON clubs(country_id);
CREATE INDEX IF NOT EXISTS idx_clubs_name ON clubs(name);

-- Club league memberships (a club can play in multiple leagues over time)
CREATE TABLE IF NOT EXISTS club_league_memberships (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  club_id UUID NOT NULL REFERENCES clubs(id) ON DELETE CASCADE,
  league_id UUID NOT NULL REFERENCES leagues(id) ON DELETE CASCADE,
  season INT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(club_id, league_id, season)
);

CREATE INDEX IF NOT EXISTS idx_club_league_memberships_club_id ON club_league_memberships(club_id);
CREATE INDEX IF NOT EXISTS idx_club_league_memberships_league_id ON club_league_memberships(league_id);

-- ============================================================================
-- PLAYERS
-- ============================================================================

CREATE TABLE IF NOT EXISTS players (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  full_name VARCHAR(200) NOT NULL, -- denormalized for easy searching
  date_of_birth DATE,
  age INT, -- cached from date_of_birth
  nationality_id UUID REFERENCES countries(id) ON DELETE SET NULL,
  image_url TEXT,
  height_cm INT,
  preferred_foot VARCHAR(10), -- left, right, both
  position_id UUID REFERENCES positions(id) ON DELETE SET NULL,
  current_club_id UUID REFERENCES clubs(id) ON DELETE SET NULL,
  overall_rating INT, -- 0-100
  international_caps INT DEFAULT 0,
  international_goals INT DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_players_full_name ON players(full_name);
CREATE INDEX IF NOT EXISTS idx_players_current_club_id ON players(current_club_id);
CREATE INDEX IF NOT EXISTS idx_players_nationality_id ON players(nationality_id);
CREATE INDEX IF NOT EXISTS idx_players_position_id ON players(position_id);
CREATE INDEX IF NOT EXISTS idx_players_overall_rating ON players(overall_rating DESC);

-- Player transfer history
CREATE TABLE IF NOT EXISTS player_transfers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  from_club_id UUID REFERENCES clubs(id) ON DELETE SET NULL,
  to_club_id UUID NOT NULL REFERENCES clubs(id) ON DELETE RESTRICT,
  transfer_date DATE NOT NULL,
  transfer_fee_million DECIMAL(10, 2),
  season INT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_player_transfers_player_id ON player_transfers(player_id);
CREATE INDEX IF NOT EXISTS idx_player_transfers_to_club_id ON player_transfers(to_club_id);
CREATE INDEX IF NOT EXISTS idx_player_transfers_transfer_date ON player_transfers(transfer_date);

-- ============================================================================
-- TOURNAMENTS
-- ============================================================================

CREATE TABLE IF NOT EXISTS tournaments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(200) NOT NULL,
  season INT NOT NULL,
  country_id UUID REFERENCES countries(id) ON DELETE SET NULL,
  logo_url TEXT,
  format VARCHAR(50) NOT NULL, -- league, knockout, group_knockout, round_robin
  start_date DATE,
  end_date DATE,
  total_teams INT,
  total_groups INT DEFAULT 1,
  status VARCHAR(20) DEFAULT 'upcoming', -- upcoming, ongoing, completed
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_tournaments_season ON tournaments(season);
CREATE INDEX IF NOT EXISTS idx_tournaments_status ON tournaments(status);
CREATE INDEX IF NOT EXISTS idx_tournaments_country_id ON tournaments(country_id);

-- Tournament groups/stages
CREATE TABLE IF NOT EXISTS tournament_groups (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL, -- Group A, Group B, Knockout Round 1, etc.
  stage_number INT NOT NULL, -- 1 for group stage, 2 for knockout, etc.
  type VARCHAR(20) NOT NULL, -- group, knockout
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(tournament_id, name)
);

CREATE INDEX IF NOT EXISTS idx_tournament_groups_tournament_id ON tournament_groups(tournament_id);

-- Tournament teams/participants
CREATE TABLE IF NOT EXISTS tournament_teams (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
  group_id UUID REFERENCES tournament_groups(id) ON DELETE SET NULL,
  club_id UUID NOT NULL REFERENCES clubs(id) ON DELETE RESTRICT,
  seed INT, -- seeding position if applicable
  games_played INT DEFAULT 0,
  wins INT DEFAULT 0,
  draws INT DEFAULT 0,
  losses INT DEFAULT 0,
  goals_for INT DEFAULT 0,
  goals_against INT DEFAULT 0,
  goal_difference INT DEFAULT 0,
  points INT DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(tournament_id, club_id)
);

CREATE INDEX IF NOT EXISTS idx_tournament_teams_tournament_id ON tournament_teams(tournament_id);
CREATE INDEX IF NOT EXISTS idx_tournament_teams_group_id ON tournament_teams(group_id);
CREATE INDEX IF NOT EXISTS idx_tournament_teams_club_id ON tournament_teams(club_id);
CREATE INDEX IF NOT EXISTS idx_tournament_teams_points ON tournament_teams(points DESC);

-- ============================================================================
-- MATCHES
-- ============================================================================

CREATE TABLE IF NOT EXISTS matches (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tournament_id UUID REFERENCES tournaments(id) ON DELETE CASCADE,
  league_id UUID REFERENCES leagues(id) ON DELETE CASCADE,
  group_id UUID REFERENCES tournament_groups(id) ON DELETE SET NULL,
  home_team_id UUID NOT NULL REFERENCES clubs(id) ON DELETE RESTRICT,
  away_team_id UUID NOT NULL REFERENCES clubs(id) ON DELETE RESTRICT,
  home_score INT,
  away_score INT,
  match_date TIMESTAMP WITH TIME ZONE NOT NULL,
  status VARCHAR(20) DEFAULT 'scheduled', -- scheduled, live, completed, postponed, cancelled
  venue VARCHAR(150),
  referee VARCHAR(100),
  attendance INT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CHECK (home_team_id != away_team_id)
);

CREATE INDEX IF NOT EXISTS idx_matches_tournament_id ON matches(tournament_id);
CREATE INDEX IF NOT EXISTS idx_matches_league_id ON matches(league_id);
CREATE INDEX IF NOT EXISTS idx_matches_home_team_id ON matches(home_team_id);
CREATE INDEX IF NOT EXISTS idx_matches_away_team_id ON matches(away_team_id);
CREATE INDEX IF NOT EXISTS idx_matches_match_date ON matches(match_date);
CREATE INDEX IF NOT EXISTS idx_matches_status ON matches(status);

-- ============================================================================
-- PLAYER MATCH EVENTS
-- ============================================================================

CREATE TABLE IF NOT EXISTS player_match_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
  player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  club_id UUID NOT NULL REFERENCES clubs(id) ON DELETE RESTRICT,
  goals INT DEFAULT 0,
  assists INT DEFAULT 0,
  yellow_cards INT DEFAULT 0,
  red_cards INT DEFAULT 0,
  player_of_match BOOLEAN DEFAULT FALSE,
  minutes_played INT,
  rating DECIMAL(3, 1), -- 0.0 to 10.0
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(match_id, player_id)
);

CREATE INDEX IF NOT EXISTS idx_player_match_events_match_id ON player_match_events(match_id);
CREATE INDEX IF NOT EXISTS idx_player_match_events_player_id ON player_match_events(player_id);
CREATE INDEX IF NOT EXISTS idx_player_match_events_club_id ON player_match_events(club_id);

-- Player statistics aggregation (for performance)
CREATE TABLE IF NOT EXISTS player_season_stats (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  club_id UUID NOT NULL REFERENCES clubs(id) ON DELETE CASCADE,
  season INT NOT NULL,
  league_id UUID REFERENCES leagues(id) ON DELETE SET NULL,
  matches_played INT DEFAULT 0,
  matches_started INT DEFAULT 0,
  goals INT DEFAULT 0,
  assists INT DEFAULT 0,
  yellow_cards INT DEFAULT 0,
  red_cards INT DEFAULT 0,
  total_minutes INT DEFAULT 0,
  average_rating DECIMAL(3, 1),
  player_of_match_count INT DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(player_id, club_id, season, league_id)
);

CREATE INDEX IF NOT EXISTS idx_player_season_stats_player_id ON player_season_stats(player_id);
CREATE INDEX IF NOT EXISTS idx_player_season_stats_club_id ON player_season_stats(club_id);
CREATE INDEX IF NOT EXISTS idx_player_season_stats_season ON player_season_stats(season);
CREATE INDEX IF NOT EXISTS idx_player_season_stats_goals ON player_season_stats(goals DESC);

-- ============================================================================
-- SECURITY & ROW LEVEL SECURITY SETUP
-- ============================================================================

-- Enable Row Level Security on all tables (commented out - enable based on auth strategy)
-- ALTER TABLE countries ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE leagues ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE clubs ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE players ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE tournaments ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE matches ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE player_match_events ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE player_season_stats ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- VIEWS FOR COMMON QUERIES
-- ============================================================================

-- Match standings for a tournament
CREATE OR REPLACE VIEW v_tournament_standings AS
SELECT 
  tt.tournament_id,
  tt.group_id,
  c.name as club_name,
  c.logo_url,
  tt.seed,
  tt.games_played,
  tt.wins,
  tt.draws,
  tt.losses,
  tt.goals_for,
  tt.goals_against,
  tt.goal_difference,
  tt.points,
  ROW_NUMBER() OVER (PARTITION BY tt.tournament_id, tt.group_id ORDER BY tt.points DESC, tt.goal_difference DESC, tt.goals_for DESC) as position
FROM tournament_teams tt
JOIN clubs c ON tt.club_id = c.id
ORDER BY tt.tournament_id, tt.group_id, tt.points DESC, tt.goal_difference DESC, tt.goals_for DESC;

-- Player performance in matches
CREATE OR REPLACE VIEW v_player_match_performance AS
SELECT 
  pme.match_id,
  pme.player_id,
  p.full_name,
  p.position_id,
  pos.name as position_name,
  pme.goals,
  pme.assists,
  pme.yellow_cards,
  pme.red_cards,
  pme.player_of_match,
  pme.minutes_played,
  pme.rating,
  c.name as club_name,
  c.logo_url as club_logo,
  m.match_date,
  m.home_score,
  m.away_score
FROM player_match_events pme
JOIN players p ON pme.player_id = p.id
JOIN clubs c ON pme.club_id = c.id
JOIN matches m ON pme.match_id = m.id
LEFT JOIN positions pos ON p.position_id = pos.id;

-- Top scorers in tournaments
CREATE OR REPLACE VIEW v_tournament_top_scorers AS
SELECT 
  t.tournament_id,
  pss.player_id,
  p.full_name,
  p.image_url,
  pss.club_id,
  c.name as club_name,
  c.logo_url as club_logo,
  pss.goals,
  pss.assists,
  pss.matches_played,
  ROUND(CAST(pss.goals AS DECIMAL) / NULLIF(pss.matches_played, 0), 2) as goals_per_match,
  ROW_NUMBER() OVER (PARTITION BY t.tournament_id ORDER BY pss.goals DESC) as rank
FROM tournament_teams t
JOIN player_season_stats pss ON pss.club_id = t.club_id
JOIN players p ON pss.player_id = p.id
JOIN clubs c ON pss.club_id = c.id;

-- Recent matches
CREATE OR REPLACE VIEW v_recent_matches AS
SELECT 
  m.id,
  m.match_date,
  m.status,
  h.name as home_team,
  h.logo_url as home_logo,
  a.name as away_team,
  a.logo_url as away_logo,
  m.home_score,
  m.away_score,
  m.venue,
  CASE 
    WHEN m.home_score > m.away_score THEN h.name
    WHEN m.away_score > m.home_score THEN a.name
    ELSE 'Draw'
  END as result,
  t.name as tournament_name,
  l.name as league_name
FROM matches m
JOIN clubs h ON m.home_team_id = h.id
JOIN clubs a ON m.away_team_id = a.id
LEFT JOIN tournaments t ON m.tournament_id = t.id
LEFT JOIN leagues l ON m.league_id = l.id
ORDER BY m.match_date DESC;
