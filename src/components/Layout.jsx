import { Outlet, NavLink, useNavigate } from 'react-router-dom'
import { useState } from 'react'
import {
  LayoutDashboard, Car, ShoppingBasket, Building2, Hospital,
  Phone, Mountain, HandHeart, Activity, Briefcase, Bus,
  LogOut, Menu, X, ChevronRight
} from 'lucide-react'

const modules = [
  { path: '/bapenda', label: 'Bapenda Jatim', icon: Car, color: '#1565C0', sub: 'Pajak Kendaraan' },
  { path: '/harga-bahan-pokok', label: 'Harga Bahan Pokok', icon: ShoppingBasket, color: '#2E7D32', sub: 'Komoditas & Price Alert' },
  { path: '/islamic-center', label: 'Islamic Center', icon: Building2, color: '#6A1B9A', sub: 'Event & Booking' },
  { path: '/rsud', label: 'RSUD Dr. Saiful Anwar', icon: Hospital, color: '#C62828', sub: 'Antrean Online' },
  { path: '/nomer-darurat', label: 'Nomer Darurat', icon: Phone, color: '#E65100', sub: 'Kontak Darurat' },
  { path: '/destinasi-wisata', label: 'Destinasi Wisata', icon: Mountain, color: '#00695C', sub: 'Katalog & E-Ticket' },
  { path: '/info-bansos', label: 'Info Bansos', icon: HandHeart, color: '#F57F17', sub: 'Status Penerima' },
  { path: '/etibi', label: 'Skrining E-Tibi', icon: Activity, color: '#00838F', sub: 'Pemantauan TBC' },
  { path: '/sinaker', label: 'Sinaker', icon: Briefcase, color: '#283593', sub: 'Lowongan Kerja' },
  { path: '/transjatim', label: 'Transjatim', icon: Bus, color: '#558B2F', sub: 'Armada & E-Ticket' },
]

function Sidebar({ open, setOpen }) {
  const navigate = useNavigate()

  return (
    <>
      {/* Overlay mobile */}
      {open && (
        <div className="fixed inset-0 bg-black/50 z-20 lg:hidden" onClick={() => setOpen(false)} />
      )}

      <aside className={`fixed top-0 left-0 h-full z-30 flex flex-col transition-transform duration-300
        lg:relative lg:translate-x-0 lg:flex
        ${open ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'}
        w-64`}
        style={{ background: '#0D2137' }}>

        {/* Header */}
        <div className="flex items-center gap-3 px-5 py-5 border-b border-white/10">
          <div className="w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0"
            style={{ background: 'linear-gradient(135deg, #1565C0, #1E88E5)' }}>
            <span className="text-white font-bold text-lg">M</span>
          </div>
          <div>
            <div className="text-white font-bold text-base leading-tight">Majadigi</div>
            <div className="text-blue-300 text-xs">Admin Portal</div>
          </div>
          <button className="ml-auto lg:hidden text-gray-400" onClick={() => setOpen(false)}>
            <X size={18} />
          </button>
        </div>

        {/* Nav */}
        <nav className="flex-1 overflow-y-auto py-3 px-3">
          {/* Dashboard */}
          <NavLink to="/dashboard" onClick={() => setOpen(false)}
            className={({ isActive }) =>
              `flex items-center gap-3 px-3 py-2.5 rounded-lg mb-1 sidebar-item cursor-pointer
               ${isActive ? 'bg-blue-600/20 border border-blue-500/30' : 'hover:bg-white/5'}`}>
            {({ isActive }) => (
              <>
                <div className={`w-8 h-8 rounded-lg flex items-center justify-center flex-shrink-0
                  ${isActive ? 'bg-blue-500/30' : 'bg-white/5'}`}>
                  <LayoutDashboard size={16} color={isActive ? '#60A5FA' : '#90A4AE'} />
                </div>
                <span className={`text-sm font-medium ${isActive ? 'text-white' : 'text-slate-400'}`}>
                  Dashboard
                </span>
                {isActive && <ChevronRight size={14} className="ml-auto text-blue-400" />}
              </>
            )}
          </NavLink>

          {/* Divider */}
          <div className="px-2 py-2">
            <p className="text-xs font-bold tracking-widest" style={{ color: '#546E7A' }}>MODUL LAYANAN</p>
          </div>

          {/* Modules */}
          {modules.map((m) => {
            const Icon = m.icon
            return (
              <NavLink key={m.path} to={m.path} onClick={() => setOpen(false)}
                className={({ isActive }) =>
                  `flex items-center gap-3 px-3 py-2.5 rounded-lg mb-1 sidebar-item cursor-pointer
                   ${isActive ? 'border' : 'hover:bg-white/5 border border-transparent'}`}
                style={({ isActive }) => isActive ? {
                  background: m.color + '18',
                  borderColor: m.color + '40',
                } : {}}>
                {({ isActive }) => (
                  <>
                    <div className="w-8 h-8 rounded-lg flex items-center justify-center flex-shrink-0"
                      style={{ background: isActive ? m.color + '30' : 'rgba(255,255,255,0.05)' }}>
                      <Icon size={16} color={isActive ? m.color : '#90A4AE'} />
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className={`text-sm font-medium truncate ${isActive ? 'text-white' : 'text-slate-400'}`}>
                        {m.label}
                      </div>
                    </div>
                    {isActive && (
                      <div className="w-2 h-2 rounded-full flex-shrink-0" style={{ background: m.color }} />
                    )}
                  </>
                )}
              </NavLink>
            )
          })}
        </nav>

        {/* Footer */}
        <div className="p-3">
          <div className="flex items-center gap-3 p-3 rounded-xl" style={{ background: 'rgba(255,255,255,0.05)', border: '1px solid rgba(255,255,255,0.08)' }}>
            <div className="w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0"
              style={{ background: 'linear-gradient(135deg,#1565C0,#1E88E5)' }}>
              <span className="text-white font-bold text-sm">A</span>
            </div>
            <div className="flex-1 min-w-0">
              <div className="text-white text-xs font-semibold truncate">Admin Diskominfo</div>
              <div className="text-blue-300 text-xs">DSK • Super Admin</div>
            </div>
            <button onClick={() => navigate('/login')} className="text-slate-400 hover:text-red-400 transition-colors">
              <LogOut size={16} />
            </button>
          </div>
        </div>
      </aside>
    </>
  )
}

export default function Layout() {
  const [sidebarOpen, setSidebarOpen] = useState(false)

  return (
    <div className="flex h-screen overflow-hidden">
      <Sidebar open={sidebarOpen} setOpen={setSidebarOpen} />
      <div className="flex-1 flex flex-col min-w-0 overflow-hidden">
        {/* Mobile topbar */}
        <div className="lg:hidden flex items-center gap-3 px-4 py-3 bg-white border-b border-gray-200">
          <button onClick={() => setSidebarOpen(true)} className="text-gray-600">
            <Menu size={22} />
          </button>
          <span className="font-bold text-gray-800">Majadigi Admin</span>
        </div>
        <main className="flex-1 overflow-y-auto">
          <Outlet />
        </main>
      </div>
    </div>
  )
}
