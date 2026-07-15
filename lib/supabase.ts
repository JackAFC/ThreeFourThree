import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || ''
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || ''

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Database types for TypeScript
export type Database = {
  public: {
    Tables: {
      countries: {
        Row: {
          id: string
          code: string
          name: string
          flag_emoji: string | null
          created_at: string
        }
        Insert: {
          id?: string
          code: string
          name: string
          flag_emoji?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          code?: string
          name?: string
          flag_emoji?: string | null
          created_at?: string
        }
      }
      positions: {
        Row: {
          id: string
          code: string
          name: string
          category: string
          created_at: string
        }
        Insert: {
          id?: string
          code: string
          name: string
          category: string
          created_at?: string
        }
        Update: {
          id?: string
          code?: string
          name?: string
          category?: string
          created_at?: string
        }
      }
      leagues: {
        Row: {
          id: string
          name: string
          country_id: string
          logo_url: string | null
          tier: number | null
          season: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          name: string
          country_id: string
          logo_url?: string | null
          tier?: number | null
          season: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          name?: string
          country_id?: string
          logo_url?: string | null
          tier?: number | null
          season?: number
          created_at?: string
          updated_at?: string
        }
      }
      clubs: {
        Row: {
          id: string
          name: string
          country_id: string
          logo_url: string | null
          stadium_name: string | null
          manager_name: string | null
          founded_year: number | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          name: string
          country_id: string
          logo_url?: string | null
          stadium_name?: string | null
          manager_name?: string | null
          founded_year?: number | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          name?: string
          country_id?: string
          logo_url?: string | null
          stadium_name?: string | null
          manager_name?: string | null
          founded_year?: number | null
          created_at?: string
          updated_at?: string
        }
      }
      players: {
        Row: {
          id: string
          first_name: string
          last_name: string
          full_name: string
          date_of_birth: string | null
          age: number | null
          nationality_id: string | null
          image_url: string | null
          height_cm: number | null
          preferred_foot: string | null
          position_id: string | null
          current_club_id: string | null
          overall_rating: number | null
          international_caps: number
          international_goals: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          first_name: string
          last_name: string
          full_name: string
          date_of_birth?: string | null
          age?: number | null
          nationality_id?: string | null
          image_url?: string | null
          height_cm?: number | null
          preferred_foot?: string | null
          position_id?: string | null
          current_club_id?: string | null
          overall_rating?: number | null
          international_caps?: number
          international_goals?: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          first_name?: string
          last_name?: string
          full_name?: string
          date_of_birth?: string | null
          age?: number | null
          nationality_id?: string | null
          image_url?: string | null
          height_cm?: number | null
          preferred_foot?: string | null
          position_id?: string | null
          current_club_id?: string | null
          overall_rating?: number | null
          international_caps?: number
          international_goals?: number
          created_at?: string
          updated_at?: string
        }
      }
      tournaments: {
        Row: {
          id: string
          name: string
          season: number
          country_id: string | null
          logo_url: string | null
          format: string
          start_date: string | null
          end_date: string | null
          total_teams: number | null
          total_groups: number
          status: string
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          name: string
          season: number
          country_id?: string | null
          logo_url?: string | null
          format: string
          start_date?: string | null
          end_date?: string | null
          total_teams?: number | null
          total_groups?: number
          status?: string
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          name?: string
          season?: number
          country_id?: string | null
          logo_url?: string | null
          format?: string
          start_date?: string | null
          end_date?: string | null
          total_teams?: number | null
          total_groups?: number
          status?: string
          created_at?: string
          updated_at?: string
        }
      }
      matches: {
        Row: {
          id: string
          tournament_id: string | null
          league_id: string | null
          group_id: string | null
          home_team_id: string
          away_team_id: string
          home_score: number | null
          away_score: number | null
          match_date: string
          status: string
          venue: string | null
          referee: string | null
          attendance: number | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          tournament_id?: string | null
          league_id?: string | null
          group_id?: string | null
          home_team_id: string
          away_team_id: string
          home_score?: number | null
          away_score?: number | null
          match_date: string
          status?: string
          venue?: string | null
          referee?: string | null
          attendance?: number | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          tournament_id?: string | null
          league_id?: string | null
          group_id?: string | null
          home_team_id?: string
          away_team_id?: string
          home_score?: number | null
          away_score?: number | null
          match_date?: string
          status?: string
          venue?: string | null
          referee?: string | null
          attendance?: number | null
          created_at?: string
          updated_at?: string
        }
      }
    }
    Views: {
      v_tournament_standings: {
        Row: {
          tournament_id: string | null
          group_id: string | null
          club_name: string | null
          logo_url: string | null
          seed: number | null
          games_played: number | null
          wins: number | null
          draws: number | null
          losses: number | null
          goals_for: number | null
          goals_against: number | null
          goal_difference: number | null
          points: number | null
          position: number | null
        }
      }
      v_recent_matches: {
        Row: {
          id: string | null
          match_date: string | null
          status: string | null
          home_team: string | null
          home_logo: string | null
          away_team: string | null
          away_logo: string | null
          home_score: number | null
          away_score: number | null
          venue: string | null
          result: string | null
          tournament_name: string | null
          league_name: string | null
        }
      }
    }
    Functions: {}
    Enums: {}
  }
}
