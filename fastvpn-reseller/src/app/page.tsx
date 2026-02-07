export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <h1 className="text-4xl font-bold">FastVPN Reseller Portal</h1>
      <p className="mt-4 text-xl">Access Fast, Stay Secure</p>
      <div className="mt-8 grid grid-cols-1 gap-4 sm:grid-cols-2">
        <div className="rounded-lg border p-6 text-center">
          <h2 className="text-2xl font-semibold">Active Users</h2>
          <p className="text-4xl font-bold text-blue-600">1,234</p>
        </div>
        <div className="rounded-lg border p-6 text-center">
          <h2 className="text-2xl font-semibold">Server Status</h2>
          <p className="text-4xl font-bold text-green-600">Online</p>
        </div>
      </div>
    </main>
  )
}
