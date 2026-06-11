import { useNavigate } from 'react-router-dom'
import { Car, ShoppingBasket, Building2, Hospital, Phone, Mountain, HandHeart, Activity, Briefcase, Bus, TrendingUp, Users, Receipt, AlertCircle } from 'lucide-react'
import { StatCard, SectionHeader } from '../../components/UI'
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts'

const modules = [
  { path: '/bapenda', label: 'Bapenda Jatim', icon: Car, color: '#1565C0', sub: 'Pajak Kendaraan' },
  { path: '/harga-bahan-pokok', label: 'Harga Bahan Pokok', icon: ShoppingBasket, color: '#2E7D32', sub: 'Komoditas' },
  { path: '/islamic-center', label: 'Islamic Center', icon: Building2, color: '#6A1B9A', sub: 'Event & Booking' },
  { path: '/rsud', label: 'RSUD Saiful Anwar', icon: Hospital, color: '#C62828', sub: 'Antrean Online' },
  { path: '/nomer-darurat', label: 'Nomer Darurat', icon: Phone, color: '#E65100', sub: 'Kontak Darurat' },
  { path: '/destinasi-wisata', label: 'Destinasi Wisata', icon: Mountain, color: '#00695C', sub: 'E-Ticketing' },
  { path: '/info-bansos', label: 'Info Bansos', icon: HandHeart, color: '#F57F17', sub: 'Status Penerima' },
  { path: '/etibi', label: 'Skrining E-Tibi', icon: Activity, color: '#00838F', sub: 'Pasien TBC' },
  { path: '/sinaker', label: 'Sinaker', icon: Briefcase, color: '#283593', sub: 'Lowongan Kerja' },
  { path: '/transjatim', label: 'Transjatim', icon: Bus, color: '#558B2F', sub: 'Armada Bus' },
]

const chartData = [
  { name: 'Sen', transaksi: 2400 }, { name: 'Sel', transaksi: 1398 },
  { name: 'Rab', transaksi: 3200 }, { name: 'Kam', transaksi: 2800 },
  { name: 'Jum', transaksi: 4100 }, { name: 'Sab', transaksi: 1900 },
  { name: 'Min', transaksi: 1200 },
]

const recentActivity = [
  { title: 'Pembayaran pajak PKB berhasil — B 1234 XYZ', time: '2 menit lalu', color: '#2E7D32', icon: Car },
  { title: 'Booking Islamic Center baru — Ahmad Fauzi', time: '15 menit lalu', color: '#6A1B9A', icon: Building2 },
  { title: 'Lowongan baru — PT Semen Indonesia', time: '1 jam lalu', color: '#283593', icon: Briefcase },
  { title: 'Harga beras diperbarui — Admin Disperindag', time: '2 jam lalu', color: '#2E7D32', icon: ShoppingBasket },
  { title: 'Antrean RSUD — 50 pasien terdaftar hari ini', time: '3 jam lalu', color: '#C62828', icon: Hospital },
]

export default function Dashboard() {
  const navigate = useNavigate()
  return (
    <div className="p-6">
      {/* Welcome Banner */}
      <div className="rounded-2xl p-6 mb-6 text-white"
        style={{ background: 'linear-gradient(135deg, #0D47A1, #1E88E5)' }}>
        <h1 className="text-xl font-bold mb-1">Selamat Datang, Admin 👋</h1>
        <p className="text-blue-200 text-sm">Portal Admin Majadigi — Super App Layanan Publik Jawa Timur</p>
        <div className="flex gap-4 mt-4">
          {[['10', 'Modul Aktif'], ['124.8K', 'Total Pengguna'], ['3.241', 'Transaksi Hari Ini']].map(([v, l]) => (
            <div key={l} className="bg-white/15 rounded-xl px-4 py-3 flex-1">
              <div className="text-lg font-bold">{v}</div>
              <div className="text-blue-200 text-xs">{l}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <StatCard title="Pembayaran Pajak" value="Rp 842 Jt" icon={TrendingUp} color="#1565C0" subtitle="+12% dari kemarin" />
        <StatCard title="Antrean RSUD Online" value="218" icon={Hospital} color="#C62828" subtitle="Hari ini" />
        <StatCard title="Lowongan Aktif" value="1.042" icon={Briefcase} color="#283593" subtitle="342 perusahaan" />
        <StatCard title="Booking Islamic Center" value="37" icon={Building2} color="#6A1B9A" subtitle="Menunggu approval" />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
        {/* Chart */}
        <div className="card p-5 lg:col-span-2">
          <SectionHeader title="Transaksi 7 Hari Terakhir" />
          <ResponsiveContainer width="100%" height={220}>
            <BarChart data={chartData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
              <XAxis dataKey="name" tick={{ fontSize: 12 }} />
              <YAxis tick={{ fontSize: 12 }} />
              <Tooltip />
              <Bar dataKey="transaksi" fill="#1565C0" radius={[6, 6, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>

        {/* Activity */}
        <div className="card p-5">
          <SectionHeader title="Aktivitas Terbaru" />
          <div className="space-y-3">
            {recentActivity.map((a, i) => {
              const Icon = a.icon
              return (
                <div key={i} className="flex gap-3 items-start">
                  <div className="w-8 h-8 rounded-lg flex items-center justify-center flex-shrink-0"
                    style={{ background: a.color + '18' }}>
                    <Icon size={14} color={a.color} />
                  </div>
                  <div>
                    <p className="text-xs text-gray-700 leading-snug">{a.title}</p>
                    <p className="text-xs text-gray-400 mt-0.5">{a.time}</p>
                  </div>
                </div>
              )
            })}
          </div>
        </div>
      </div>

      {/* Module Grid */}
      <SectionHeader title="Akses Cepat Modul" />
      <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-3">
        {modules.map((m) => {
          const Icon = m.icon
          return (
            <button key={m.path} onClick={() => navigate(m.path)}
              className="card p-4 flex flex-col items-center gap-2 hover:shadow-md transition-all cursor-pointer text-center group">
              <div className="w-12 h-12 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform"
                style={{ background: m.color + '18' }}>
                <Icon size={22} color={m.color} />
              </div>
              <div>
                <p className="text-xs font-semibold text-gray-800 leading-tight">{m.label}</p>
                <p className="text-xs text-gray-400 mt-0.5">{m.sub}</p>
              </div>
            </button>
          )
        })}
      </div>
    </div>
  )
}
