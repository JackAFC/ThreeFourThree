'use client'

import { useEffect, useState } from 'react'
import { supabase } from '@/lib/supabase'

interface Country {
  id: string
  code: string
  name: string
  flag_emoji: string | null
}

interface Position {
  id: string
  code: string
  name: string
  category: string
}

export default function Home() {
  const [countries, setCountries] = useState<Country[]>([])
  const [positions, setPositions] = useState<Position[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true)
        
        // Fetch countries
        const { data: countriesData, error: countriesError } = await supabase
          .from('countries')
          .select('*')
          .order('name')

        if (countriesError) throw countriesError

        // Fetch positions
        const { data: positionsData, error: positionsError } = await supabase
          .from('positions')
          .select('*')
          .order('name')

        if (positionsError) throw positionsError

        setCountries(countriesData || [])
        setPositions(positionsData || [])
      } catch (err) {
        setError(err instanceof Error ? err.message : 'An error occurred')
        console.error('Error fetching data:', err)
      } finally {
        setLoading(false)
      }
    }

    fetchData()
  }, [])

  return (
    <main className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-8">
      <div className="max-w-6xl mx-auto">
        {/* Header */}
        <div className="text-center mb-12">
          <h1 className="text-4xl md:text-5xl font-bold text-gray-900 mb-4">
            ⚽ ThreeFourThree Football
          </h1>
          <p className="text-xl text-gray-600">
            Tournament Management System
          </p>
        </div>

        {/* Status Message */}
        {loading && (
          <div className="text-center mb-8">
            <p className="text-lg text-gray-700 animate-pulse">
              Loading data from database...
            </p>
          </div>
        )}

        {error && (
          <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-8">
            <p className="font-bold">Error</p>
            <p>{error}</p>
          </div>
        )}

        {!loading && !error && (
          <>
            {/* Database Connection Status */}
            <div className="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-8">
              <p className="font-bold">✅ Database Connected Successfully!</p>
              <p>Loaded {countries.length} countries and {positions.length} positions</p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
              {/* Countries Section */}
              <div className="bg-white rounded-lg shadow-lg p-6">
                <h2 className="text-2xl font-bold text-gray-900 mb-4">
                  🌍 Countries ({countries.length})
                </h2>
                <div className="space-y-2 max-h-96 overflow-y-auto">
                  {countries.map((country) => (
                    <div
                      key={country.id}
                      className="flex items-center p-3 bg-gray-50 rounded hover:bg-gray-100 transition"
                    >
                      <span className="text-2xl mr-3">
                        {country.flag_emoji || '🚩'}
                      </span>
                      <div className="flex-1">
                        <p className="font-semibold text-gray-900">
                          {country.name}
                        </p>
                        <p className="text-sm text-gray-600">{country.code}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Positions Section */}
              <div className="bg-white rounded-lg shadow-lg p-6">
                <h2 className="text-2xl font-bold text-gray-900 mb-4">
                  👕 Positions ({positions.length})
                </h2>
                <div className="space-y-2 max-h-96 overflow-y-auto">
                  {positions.map((position) => (
                    <div
                      key={position.id}
                      className="flex items-center p-3 bg-gray-50 rounded hover:bg-gray-100 transition"
                    >
                      <div className="flex-1">
                        <p className="font-semibold text-gray-900">
                          {position.name}
                        </p>
                        <div className="flex gap-2 text-sm">
                          <span className="bg-blue-100 text-blue-800 px-2 py-1 rounded">
                            {position.code}
                          </span>
                          <span className="bg-purple-100 text-purple-800 px-2 py-1 rounded capitalize">
                            {position.category}
                          </span>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>

            {/* Next Steps */}
            <div className="mt-12 bg-indigo-50 border-2 border-indigo-200 rounded-lg p-8">
              <h3 className="text-2xl font-bold text-gray-900 mb-4">
                🚀 Next Steps
              </h3>
              <ul className="space-y-3 text-gray-700">
                <li className="flex items-start">
                  <span className="text-indigo-600 font-bold mr-3">1.</span>
                  <span>
                    Add clubs and leagues to your database
                  </span>
                </li>
                <li className="flex items-start">
                  <span className="text-indigo-600 font-bold mr-3">2.</span>
                  <span>
                    Create tournaments and matches
                  </span>
                </li>
                <li className="flex items-start">
                  <span className="text-indigo-600 font-bold mr-3">3.</span>
                  <span>
                    Add players and track their performance
                  </span>
                </li>
                <li className="flex items-start">
                  <span className="text-indigo-600 font-bold mr-3">4.</span>
                  <span>
                    Build league tables and player statistics
                  </span>
                </li>
              </ul>
            </div>
          </>
        )}
      </div>
    </main>
  )
}
