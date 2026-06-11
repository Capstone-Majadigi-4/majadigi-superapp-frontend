import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import Login from './pages/Login'
import Layout from './components/Layout'
import Dashboard from './pages/dashboard/Dashboard'
import Bapenda from './pages/bapenda/Bapenda'
import HargaBahanPokok from './pages/hargaBahanPokok/HargaBahanPokok'
import IslamicCenter from './pages/islamicCenter/IslamicCenter'
import Rsud from './pages/rsud/Rsud'
import NomerDarurat from './pages/nomerDarurat/NomerDarurat'
import DestinasiWisata from './pages/destinasiWisata/DestinasiWisata'
import InfoBansos from './pages/infoBansos/InfoBansos'
import Etibi from './pages/etibi/Etibi'
import Sinaker from './pages/sinaker/Sinaker'
import Transjatim from './pages/transjatim/Transjatim'

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/" element={<Layout />}>
          <Route index element={<Navigate to="/dashboard" replace />} />
          <Route path="dashboard" element={<Dashboard />} />
          <Route path="bapenda" element={<Bapenda />} />
          <Route path="harga-bahan-pokok" element={<HargaBahanPokok />} />
          <Route path="islamic-center" element={<IslamicCenter />} />
          <Route path="rsud" element={<Rsud />} />
          <Route path="nomer-darurat" element={<NomerDarurat />} />
          <Route path="destinasi-wisata" element={<DestinasiWisata />} />
          <Route path="info-bansos" element={<InfoBansos />} />
          <Route path="etibi" element={<Etibi />} />
          <Route path="sinaker" element={<Sinaker />} />
          <Route path="transjatim" element={<Transjatim />} />
        </Route>
        <Route path="*" element={<Navigate to="/dashboard" replace />} />
      </Routes>
    </BrowserRouter>
  )
}
