'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
const supabase = createClient(supabaseUrl!, supabaseKey!)

export default function Home() {
  const [countries, setCountries] = useState<any[]>([])
  const [positions, setPositions] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    const fetchData = async () => {
      try {
        // Fetch countries
        const { data: countriesData, error: countriesError } = await supabase
          .from('countries')
          .select('*')

        if (countriesError) throw countriesError

        // Fetch positions
        const { data: positionsData, error: positionsError } = await supabase
          .from('positions')
          .select('*')

        if (positionsError) throw positionsError

        setCountries(countriesData || [])
        setPositions(positionsData || [])
        setError(null)
      } catch (err: any) {
        setError(err.message || 'Failed to load data')
        console.error(err)
      } finally {
        setLoading(false)
      }
    }

    fetchData()
  }, [])

  return (
    <main className="min-h-screen bg-gradient-to-br from-blue-50 to-green-50 p-8">
      <div className="max-w-6xl mx-auto">
        {/* Header */}
        <div className="text-center mb-12">
          <h1 className="text-5xl font-bold text-gray-900 mb-2">
            ⚽ ThreeFourThree Football
          </h1>
          <p className="text-xl text-gray-600">Tournament Management System</p>
        </div>

        {/* Error State */}
        {error && (
          <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-8">
            <p className="font-bold">Error</p>
            <p>{error}</p>
          </div>
        )}

        {/* Loading State */}
        {loading && (
          <div className="text-center py-12">
            <p className="text-lg text-gray-600">Loading data from database...</p>
          </div>
        )}

        {/* Main Content */}
        {!loading && !error && (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            {/* Countries Section */}
            <div className="bg-white rounded-lg shadow-lg p-6">
              <h2 className="text-2xl font-bold text-gray-900 mb-4">
                🌍 Countries ({countries.length})
              </h2>
              <div className="space-y-2 max-h-96 overflow-y-auto">
                {countries.length > 0 ? (
                  countries.map((country) => (
                    <div
                      key={country.id}
                      className="flex items-center justify-between p-2 bg-blue-50 rounded hover:bg-blue-100 transition"
                    >
                      <span className="text-lg">{country.flag}</span>
                      <span className="text-gray-800">{country.name}</span>
                    </div>
                  ))
                ) : (
                  <p className="text-gray-500">No countries found</p>
                )}
              </div>
            </div>

            {/* Positions Section */}
            <div className="bg-white rounded-lg shadow-lg p-6">
              <h2 className="text-2xl font-bold text-gray-900 mb-4">
                👥 Player Positions ({positions.length})
              </h2>
              <div className="space-y-2 max-h-96 overflow-y-auto">
                {positions.length > 0 ? (
                  positions.map((position) => (
                    <div
                      key={position.id}
                      className="flex items-center justify-between p-2 bg-green-50 rounded hover:bg-green-100 transition"
                    >
                      <span className="font-semibold text-gray-900">{position.name}</span>
                      <span className="text-sm text-gray-500">{position.abbreviation}</span>
                    </div>
                  ))
                ) : (
                  <p className="text-gray-500">No positions found</p>
                )}
              </div>
            </div>
          </div>
        )}

        {/* Stats Footer */}
        {!loading && !error && (
          <div className="mt-12 text-center text-gray-600">
            <p>✅ {countries.length} countries • ✅ {positions.length} positions</p>
          </div>
        )}
      </div>
    </main>
  )
}
