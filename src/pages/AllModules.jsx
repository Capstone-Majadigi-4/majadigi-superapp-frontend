// Bapenda
import { useState } from 'react'
import { PageHeader, Badge, Table, Tabs, Button, Modal, Input } from "../components/UI"
import { Car, Search, Plus, Trash2, Edit, CheckCircle, XCircle, ToggleLeft, ToggleRight, Building2, Phone, Mountain, HandHeart, Activity, Briefcase, Bus } from "lucide-react"
// ─── BAPENDA ──────────────────────────────────────────────────────────────────
const transaksiData = [
  { noPolisi: 'B 1234 XYZ', nama: 'Dodi Prasetyo', jenis: 'PKB + SWDKLLJ', total: 'Rp 850.000', status: 'Berhasil', waktu: '09:14, 3 Jun 2025' },
  { noPolisi: 'L 5678 ABC', nama: 'Siti Rahayu', jenis: 'PKB', total: 'Rp 620.000', status: 'Berhasil', waktu: '09:02, 3 Jun 2025' },
  { noPolisi: 'AE 9900 ZZ', nama: 'Budi Santoso', jenis: 'PKB + Denda', total: 'Rp 1.250.000', status: 'Pending', waktu: '08:55, 3 Jun 2025' },
  { noPolisi: 'W 4321 QQ', nama: 'Ahmad Fauzi', jenis: 'SWDKLLJ', total: 'Rp 143.000', status: 'Berhasil', waktu: '08:30, 3 Jun 2025' },
  { noPolisi: 'N 1111 AA', nama: 'Rina Sari', jenis: 'PKB', total: 'Rp 720.000', status: 'Kedaluwarsa', waktu: '07:50, 3 Jun 2025' },
]

export function Bapenda() {
  const [tab, setTab] = useState('rekap')
  const [filter, setFilter] = useState('Semua')
  const [query, setQuery] = useState('')
  const [result, setResult] = useState(null)

  const statusBadge = (s) => {
    const map = { Berhasil: 'success', Pending: 'warning', Kedaluwarsa: 'neutral' }
    return <Badge label={s} type={map[s] || 'neutral'} />
  }

  const filtered = transaksiData.filter(t =>
    (filter === 'Semua' || t.status === filter)
  )

  return (
    <div className="p-6">
      <PageHeader title="Bapenda Jatim" subtitle="Rekapitulasi Transaksi Pajak Kendaraan"
        actions={<div className="flex gap-2">
          {['Semua','Berhasil','Pending','Kedaluwarsa'].map(s => (
            <button key={s} onClick={() => setFilter(s)}
              className={`px-3 py-1.5 rounded-lg text-xs font-medium transition-all ${filter === s ? 'bg-blue-600 text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'}`}>
              {s}
            </button>
          ))}
        </div>}
      />

      <Tabs tabs={[{key:'rekap',label:'Rekapitulasi Transaksi'},{key:'cari',label:'Cari Kode Bayar'}]} active={tab} onChange={setTab} />

      {tab === 'rekap' && (
        <>
          <div className="grid grid-cols-3 gap-4 mb-6">
            {[['Rp 842 Jt','Total Hari Ini','#1565C0'],['1.284','Berhasil','#2E7D32'],['43','Pending','#F9A825']].map(([v,l,c]) => (
              <div key={l} className="card p-4">
                <p className="text-2xl font-bold" style={{color:c}}>{v}</p>
                <p className="text-xs text-gray-500 mt-0.5">{l}</p>
              </div>
            ))}
          </div>
          <Table
            columns={[
              {header:'No. Polisi', key:'noPolisi', render: r => <span className="font-semibold text-blue-600">{r.noPolisi}</span>},
              {header:'Nama WP', key:'nama'},
              {header:'Jenis Pajak', key:'jenis'},
              {header:'Total', key:'total', render: r => <span className="font-semibold">{r.total}</span>},
              {header:'Status', key:'status', render: r => statusBadge(r.status)},
              {header:'Waktu', key:'waktu', render: r => <span className="text-gray-400 text-xs">{r.waktu}</span>},
            ]}
            data={filtered}
          />
        </>
      )}

      {tab === 'cari' && (
        <div className="card p-6 max-w-xl">
          <p className="font-semibold text-gray-700 mb-3">Masukkan Nomor Polisi atau Kode VA</p>
          <div className="flex gap-2 mb-4">
            <input value={query} onChange={e => setQuery(e.target.value)}
              placeholder="Contoh: B 1234 XYZ atau 88810012345678"
              className="flex-1 px-3 py-2.5 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />
            <Button icon={Search} onClick={() => setResult({noPolisi:'B 4567 ABC',nama:'Dodi Prasetyo',kodeVA:'88810012345678',total:'Rp 1.250.000',status:'Menunggu Pembayaran'})}>Cari</Button>
          </div>
          {result && (
            <div className="bg-gray-50 rounded-xl p-4 space-y-2">
              {Object.entries(result).map(([k,v]) => (
                <div key={k} className="flex gap-3">
                  <span className="text-sm text-gray-500 w-32 capitalize">{k}</span>
                  <span className="text-sm font-semibold text-gray-800">{v}</span>
                </div>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  )
}

// ─── HARGA BAHAN POKOK ────────────────────────────────────────────────────────
const komoditasData = [
  {nama:'Beras Medium', satuan:'kg', ikon:'🌾', harga:'12.500', trend:'naik', persen:'+2.1%'},
  {nama:'Beras Premium', satuan:'kg', ikon:'🍚', harga:'15.000', trend:'stabil', persen:'0%'},
  {nama:'Minyak Goreng', satuan:'liter', ikon:'🫙', harga:'14.200', trend:'turun', persen:'-0.7%'},
  {nama:'Gula Pasir', satuan:'kg', ikon:'🧂', harga:'16.000', trend:'naik', persen:'+1.5%'},
  {nama:'Telur Ayam', satuan:'kg', ikon:'🥚', harga:'29.500', trend:'stabil', persen:'0%'},
  {nama:'Daging Sapi', satuan:'kg', ikon:'🥩', harga:'135.000', trend:'naik', persen:'+0.4%'},
  {nama:'Cabai Merah', satuan:'kg', ikon:'🌶️', harga:'42.000', trend:'turun', persen:'-5.2%'},
  {nama:'Bawang Merah', satuan:'kg', ikon:'🧅', harga:'28.000', trend:'naik', persen:'+3.8%'},
]

export function HargaBahanPokok() {
  const [tab, setTab] = useState('harga')
  const [list, setList] = useState(komoditasData)
  const [harga, setHarga] = useState(Object.fromEntries(komoditasData.map(k => [k.nama, k.harga])))
  const [modal, setModal] = useState(false)
  const [form, setForm] = useState({nama:'',satuan:'kg'})

  const trendColor = t => t === 'naik' ? 'text-red-600' : t === 'turun' ? 'text-green-600' : 'text-gray-400'

  return (
    <div className="p-6">
      <PageHeader title="Harga Bahan Pokok" subtitle="Kelola data harga komoditas pasar" />
      <Tabs tabs={[{key:'harga',label:'Update Harga Harian'},{key:'master',label:'Master Komoditas'}]} active={tab} onChange={setTab} />

      {tab === 'harga' && (
        <>
          <div className="flex justify-between items-center mb-4">
            <p className="text-sm text-gray-500">Terakhir diperbarui: Hari ini, 07:00 WIB</p>
            <Button variant="outline" icon={Plus}>Bulk Upload CSV</Button>
          </div>
          <div className="card overflow-hidden">
            <table className="w-full text-sm">
              <thead><tr className="bg-gray-50 border-b">
                {['Komoditas','Satuan','Harga (Rp)','Trend'].map(h => (
                  <th key={h} className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">{h}</th>
                ))}
              </tr></thead>
              <tbody className="divide-y divide-gray-100">
                {list.map((k) => (
                  <tr key={k.nama} className="hover:bg-gray-50">
                    <td className="px-4 py-3 font-semibold">{k.ikon} {k.nama}</td>
                    <td className="px-4 py-3 text-gray-500">per {k.satuan}</td>
                    <td className="px-4 py-3">
                      <input value={harga[k.nama]} onChange={e => setHarga({...harga,[k.nama]:e.target.value})}
                        className="w-28 px-2 py-1 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />
                    </td>
                    <td className={`px-4 py-3 font-semibold ${trendColor(k.trend)}`}>{k.persen}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <div className="mt-4 flex justify-end">
            <Button onClick={() => alert('Data berhasil disimpan!')}>Simpan Semua Perubahan</Button>
          </div>
        </>
      )}

      {tab === 'master' && (
        <>
          <div className="flex justify-end mb-4">
            <Button icon={Plus} onClick={() => setModal(true)}>Tambah Komoditas</Button>
          </div>
          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3">
            {list.map((k, i) => (
              <div key={i} className="card p-4 flex items-center gap-3">
                <span className="text-2xl">{k.ikon}</span>
                <div className="flex-1 min-w-0">
                  <p className="font-semibold text-sm text-gray-800 truncate">{k.nama}</p>
                  <p className="text-xs text-gray-400">per {k.satuan}</p>
                </div>
                <button onClick={() => setList(list.filter((_,j) => j !== i))}
                  className="text-red-400 hover:text-red-600"><Trash2 size={14} /></button>
              </div>
            ))}
          </div>
          <Modal open={modal} onClose={() => setModal(false)} title="Tambah Komoditas">
            <Input label="Nama Komoditas" value={form.nama} onChange={e => setForm({...form,nama:e.target.value})} />
            <Input label="Satuan (kg/liter)" value={form.satuan} onChange={e => setForm({...form,satuan:e.target.value})} />
            <Button className="w-full justify-center mt-2" onClick={() => { setList([...list,{...form,ikon:'🛒',harga:'0',trend:'stabil',persen:'0%'}]); setModal(false) }}>Simpan</Button>
          </Modal>
        </>
      )}
    </div>
  )
}

// ─── ISLAMIC CENTER ───────────────────────────────────────────────────────────
const bookingData = [
  {nama:'Ahmad Fauzi', fasilitas:'Aula Utama (kap. 1000)', tanggal:'15 Jun 2025', acara:'Pengajian Akbar Muharram', biaya:'Rp 5.000.000', status:'Menunggu'},
  {nama:'Yayasan Baitul Ilmi', fasilitas:'Ruang Seminar (kap. 200)', tanggal:'20 Jun 2025', acara:'Seminar Parenting Islami', biaya:'Rp 1.500.000', status:'Menunggu'},
  {nama:'Komunitas Pemuda', fasilitas:'Ruang Kelas A', tanggal:'10 Jun 2025', acara:'Workshop Tilawah', biaya:'Rp 500.000', status:'Disetujui'},
  {nama:'PT Amanah Sejahtera', fasilitas:'Aula Utama', tanggal:'5 Jun 2025', acara:'Gathering Karyawan', biaya:'Rp 5.000.000', status:'Ditolak'},
]

export function IslamicCenter() {
  const [tab, setTab] = useState('booking')
  const [list, setList] = useState(bookingData)
  const [events, setEvents] = useState([
    {judul:'Kajian Ramadan — Ustadz Abdul Somad', tanggal:'25 Jun 2025', kuota:'2000', pendaftar:'1847'},
    {judul:'Bimbingan Tahsin Al-Quran', tanggal:'Setiap Sabtu', kuota:'50', pendaftar:'42'},
  ])
  const [modal, setModal] = useState(false)
  const [form, setForm] = useState({judul:'',tanggal:'',kuota:''})

  const updateStatus = (i, status) => setList(list.map((b,j) => j===i ? {...b,status} : b))
  const badgeType = s => s==='Disetujui'?'success':s==='Ditolak'?'danger':'warning'

  return (
    <div className="p-6">
      <PageHeader title="Islamic Center" subtitle="Kelola booking fasilitas dan event keagamaan" />
      <Tabs tabs={[{key:'booking',label:'Permohonan Sewa'},{key:'event',label:'Kelola Event'}]} active={tab} onChange={setTab} />

      {tab === 'booking' && (
        <div className="space-y-3">
          {list.map((b, i) => (
            <div key={i} className="card p-5">
              <div className="flex items-start justify-between mb-3">
                <div>
                  <p className="font-bold text-gray-800">{b.nama}</p>
                  <p className="text-sm text-gray-500">{b.acara}</p>
                </div>
                <Badge label={b.status} type={badgeType(b.status)} />
              </div>
              <div className="grid grid-cols-2 gap-2 text-sm text-gray-600 mb-4">
                <span>📍 {b.fasilitas}</span>
                <span>📅 {b.tanggal}</span>
                <span>💰 {b.biaya}</span>
              </div>
              {b.status === 'Menunggu' && (
                <div className="flex gap-2">
                  <Button variant="outline" icon={XCircle} className="flex-1 justify-center border-red-300 text-red-600 hover:bg-red-50" onClick={() => updateStatus(i,'Ditolak')}>Tolak</Button>
                  <Button variant="success" icon={CheckCircle} className="flex-1 justify-center" onClick={() => updateStatus(i,'Disetujui')}>Setujui</Button>
                </div>
              )}
            </div>
          ))}
        </div>
      )}

      {tab === 'event' && (
        <>
          <div className="flex justify-end mb-4">
            <Button icon={Plus} onClick={() => setModal(true)}>Buat Event Baru</Button>
          </div>
          <div className="space-y-3">
            {events.map((e, i) => (
              <div key={i} className="card p-4 flex items-center gap-4">
                <div className="w-10 h-10 bg-purple-100 rounded-xl flex items-center justify-center flex-shrink-0">
                  <Building2 size={18} color="#6A1B9A" />
                </div>
                <div className="flex-1">
                  <p className="font-semibold text-gray-800">{e.judul}</p>
                  <p className="text-sm text-gray-500">📅 {e.tanggal} • 👥 {e.pendaftar}/{e.kuota} peserta</p>
                </div>
                <button onClick={() => setEvents(events.filter((_,j) => j!==i))} className="text-red-400 hover:text-red-600"><Trash2 size={16} /></button>
              </div>
            ))}
          </div>
          <Modal open={modal} onClose={() => setModal(false)} title="Buat Event Baru">
            <Input label="Judul Acara" value={form.judul} onChange={e => setForm({...form,judul:e.target.value})} />
            <Input label="Tanggal" value={form.tanggal} onChange={e => setForm({...form,tanggal:e.target.value})} />
            <Input label="Kuota Peserta" type="number" value={form.kuota} onChange={e => setForm({...form,kuota:e.target.value})} />
            <Button className="w-full justify-center mt-2" onClick={() => { setEvents([...events,{...form,pendaftar:'0'}]); setModal(false) }}>Simpan Event</Button>
          </Modal>
        </>
      )}
    </div>
  )
}

// ─── RSUD ─────────────────────────────────────────────────────────────────────
const antreanData = [
  {nomor:'001', nama:'Budi Santoso', poli:'Poli Umum', dokter:'dr. Hendra, Sp.U', status:'Selesai', eta:'08:30'},
  {nomor:'012', nama:'Siti Rahayu', poli:'Poli Umum', dokter:'dr. Hendra, Sp.U', status:'Sedang Dilayani', eta:'09:15'},
  {nomor:'013', nama:'Ahmad Fauzi', poli:'Poli Dalam', dokter:'dr. Rina, Sp.PD', status:'Menunggu', eta:'09:30'},
  {nomor:'014', nama:'Rina Puspita', poli:'Poli Dalam', dokter:'dr. Rina, Sp.PD', status:'Menunggu', eta:'09:45'},
  {nomor:'015', nama:'Dodi Prasetyo', poli:'Poli Anak', dokter:'dr. Sari, Sp.A', status:'Menunggu', eta:'10:00'},
]

export function Rsud() {
  const [tab, setTab] = useState('list')
  const [current, setCurrent] = useState(12)
  const [poli, setPoli] = useState('Poli Umum')

  const statusBadge = s => {
    const map = {'Sedang Dilayani':'info','Selesai':'success','Menunggu':'warning'}
    return <Badge label={s} type={map[s]||'neutral'} />
  }

  return (
    <div className="p-6">
      <PageHeader title="RSUD Dr. Saiful Anwar" subtitle="Manajemen Antrean Online Poliklinik" />
      <Tabs tabs={[{key:'list',label:'Daftar Antrean'},{key:'kelola',label:'Manajemen Antrean'}]} active={tab} onChange={setTab} />

      {tab === 'list' && (
        <>
          <div className="grid grid-cols-3 gap-4 mb-6">
            {[['Poli Umum',48,12,'#1565C0'],['Poli Dalam',35,7,'#C62828'],['Poli Anak',29,5,'#00838F']].map(([p,t,d,c]) => (
              <div key={p} className="card p-4" style={{borderTop:`3px solid ${c}`}}>
                <p className="font-semibold text-sm" style={{color:c}}>{p}</p>
                <p className="text-2xl font-bold mt-1" style={{color:c}}>{t}</p>
                <p className="text-xs text-gray-400">antrean • Dilayani: #{d}</p>
              </div>
            ))}
          </div>
          <Table
            columns={[
              {header:'No.', key:'nomor', render:r=><span className="font-bold text-blue-600">#{r.nomor}</span>},
              {header:'Nama Pasien', key:'nama'},
              {header:'Poliklinik', key:'poli'},
              {header:'Dokter', key:'dokter', render:r=><span className="text-xs">{r.dokter}</span>},
              {header:'Status', key:'status', render:r=>statusBadge(r.status)},
              {header:'ETA', key:'eta'},
            ]}
            data={antreanData}
          />
        </>
      )}

      {tab === 'kelola' && (
        <div className="max-w-sm mx-auto">
          <div className="mb-4 flex items-center gap-2">
            <label className="font-semibold text-sm">Poliklinik:</label>
            <select value={poli} onChange={e=>setPoli(e.target.value)}
              className="px-3 py-1.5 border border-gray-300 rounded-lg text-sm focus:outline-none">
              {['Poli Umum','Poli Dalam','Poli Anak','Poli THT'].map(p=><option key={p}>{p}</option>)}
            </select>
          </div>
          <div className="card p-8 text-center mb-4"
            style={{background:'linear-gradient(135deg,#C62828,#E53935)'}}>
            <p className="text-white/80 text-sm">Nomor Sedang Dilayani</p>
            <p className="text-white text-8xl font-black my-3">{current}</p>
            <p className="text-white/80">{poli}</p>
          </div>
          <div className="flex gap-3 mb-3">
            <Button variant="outline" className="flex-1 justify-center" onClick={()=>setCurrent(Math.max(1,current-1))}>← Mundur</Button>
            <Button className="flex-1 justify-center" style={{background:'#C62828'}} onClick={()=>setCurrent(current+1)}>Panggil Berikutnya →</Button>
          </div>
          <Button variant="outline" className="w-full justify-center" onClick={()=>alert('Antrean dilompati')}>Skip (Tidak Hadir)</Button>
        </div>
      )}
    </div>
  )
}

// ─── NOMER DARURAT ────────────────────────────────────────────────────────────
export function NomerDarurat() {
  const [list, setList] = useState([
    {kategori:'Pusat', nama:'Command Center 112', nomor:'112', aktif:true},
    {kategori:'Polisi', nama:'Polda Jawa Timur', nomor:'110', aktif:true},
    {kategori:'Medis', nama:'Ambulans / PSC 119', nomor:'119', aktif:true},
    {kategori:'Pemadam', nama:'Damkar Jatim', nomor:'113', aktif:true},
    {kategori:'SAR', nama:'Basarnas Jatim', nomor:'115', aktif:false},
  ])
  const [modal, setModal] = useState(false)
  const [form, setForm] = useState({nama:'',nomor:'',kategori:''})

  const toggle = i => setList(list.map((l,j)=>j===i?{...l,aktif:!l.aktif}:l))

  return (
    <div className="p-6">
      <PageHeader title="Nomer Darurat" subtitle="Kelola daftar nomor darurat yang tampil di aplikasi"
        actions={<Button icon={Plus} onClick={()=>setModal(true)}>Tambah Nomor</Button>} />
      <div className="bg-red-50 border border-red-200 rounded-xl p-4 mb-6 flex gap-3 items-start">
        <span className="text-red-500 flex-shrink-0">⚠️</span>
        <p className="text-sm text-red-600">Nomor darurat tampil sebagai tombol FAB global di seluruh halaman aplikasi. Pastikan semua nomor valid.</p>
      </div>
      <div className="space-y-3">
        {list.map((item, i) => (
          <div key={i} className="card p-4 flex items-center gap-4">
            <div className="w-10 h-10 bg-red-100 rounded-xl flex items-center justify-center flex-shrink-0">
              <Phone size={18} color="#C62828" />
            </div>
            <div className="flex-1">
              <p className="font-semibold text-gray-800">{item.nama}</p>
              <p className="text-sm text-gray-500">{item.kategori} • <span className="font-bold text-gray-700">{item.nomor}</span></p>
            </div>
            <button onClick={()=>toggle(i)} className={`text-2xl ${item.aktif?'text-green-500':'text-gray-300'}`}>
              {item.aktif ? '●' : '○'}
            </button>
            <Badge label={item.aktif?'Aktif':'Nonaktif'} type={item.aktif?'success':'neutral'} />
            <button onClick={()=>setList(list.filter((_,j)=>j!==i))} className="text-red-400 hover:text-red-600"><Trash2 size={16}/></button>
          </div>
        ))}
      </div>
      <Modal open={modal} onClose={()=>setModal(false)} title="Tambah Nomor Darurat">
        <Input label="Nama Layanan" value={form.nama} onChange={e=>setForm({...form,nama:e.target.value})} />
        <Input label="Nomor Telepon" value={form.nomor} onChange={e=>setForm({...form,nomor:e.target.value})} />
        <Input label="Kategori" value={form.kategori} onChange={e=>setForm({...form,kategori:e.target.value})} />
        <Button className="w-full justify-center mt-2" onClick={()=>{setList([...list,{...form,aktif:true}]);setModal(false)}}>Tambah</Button>
      </Modal>
    </div>
  )
}

// ─── DESTINASI WISATA ─────────────────────────────────────────────────────────
const wisataData = [
  {nama:'Bromo Tengger Semeru', kota:'Probolinggo', kategori:'Alam', harga:'29.000', jam:'05:00-18:00'},
  {nama:'Kawah Ijen', kota:'Banyuwangi', kategori:'Alam', harga:'15.000', jam:'01:00-14:00'},
  {nama:'Candi Singosari', kota:'Malang', kategori:'Budaya', harga:'5.000', jam:'08:00-16:00'},
  {nama:'Jatim Park 1', kota:'Batu', kategori:'Buatan', harga:'110.000', jam:'09:00-17:00'},
]

export function DestinasiWisata() {
  const [tab, setTab] = useState('katalog')
  const [list, setList] = useState(wisataData)
  const [modal, setModal] = useState(false)
  const [form, setForm] = useState({nama:'',kota:'',harga:'',jam:'',kategori:'Alam'})

  return (
    <div className="p-6">
      <PageHeader title="Destinasi Wisata" subtitle="Kelola katalog wisata dan validasi tiket" />
      <Tabs tabs={[{key:'katalog',label:'Katalog Wisata'},{key:'tiket',label:'Validasi Tiket'}]} active={tab} onChange={setTab} />

      {tab === 'katalog' && (
        <>
          <div className="flex justify-end mb-4">
            <Button icon={Plus} onClick={()=>setModal(true)}>Tambah Destinasi</Button>
          </div>
          <Table
            columns={[
              {header:'Destinasi', key:'nama', render:r=><span className="font-semibold">{r.nama}</span>},
              {header:'Kota', key:'kota'},
              {header:'Kategori', key:'kategori', render:r=><Badge label={r.kategori} type={r.kategori==='Alam'?'success':r.kategori==='Budaya'?'info':'warning'}/>},
              {header:'Harga Tiket', key:'harga', render:r=><span className="font-semibold">Rp {r.harga}</span>},
              {header:'Jam Buka', key:'jam'},
              {header:'Aksi', render:(r,i)=><button onClick={()=>setList(list.filter((_,j)=>j!==i))} className="text-red-400 hover:text-red-600"><Trash2 size={14}/></button>},
            ]}
            data={list}
          />
          <Modal open={modal} onClose={()=>setModal(false)} title="Tambah Destinasi">
            <Input label="Nama Destinasi" value={form.nama} onChange={e=>setForm({...form,nama:e.target.value})} />
            <Input label="Kota/Kabupaten" value={form.kota} onChange={e=>setForm({...form,kota:e.target.value})} />
            <Input label="Harga Tiket (Rp)" value={form.harga} onChange={e=>setForm({...form,harga:e.target.value})} />
            <Input label="Jam Operasional" value={form.jam} onChange={e=>setForm({...form,jam:e.target.value})} />
            <Button className="w-full justify-center mt-2" onClick={()=>{setList([...list,form]);setModal(false)}}>Simpan</Button>
          </Modal>
        </>
      )}

      {tab === 'tiket' && (
        <div className="flex flex-col items-center justify-center py-16">
          <div className="w-24 h-24 bg-green-100 rounded-2xl flex items-center justify-center mb-4">
            <span className="text-4xl">📷</span>
          </div>
          <p className="font-bold text-gray-800 text-lg mb-2">Scanner E-Ticket Wisata</p>
          <p className="text-sm text-gray-500 text-center mb-6 max-w-sm">Gunakan kamera untuk memindai QR Code tiket pengunjung di pintu masuk wisata</p>
          <Button variant="success" onClick={()=>alert('Kamera scanner akan terbuka')}>Buka Kamera Scanner</Button>
        </div>
      )}
    </div>
  )
}

// ─── INFO BANSOS ──────────────────────────────────────────────────────────────
export function InfoBansos() {
  const [tab, setTab] = useState('sinkron')
  const [pengumuman, setPengumuman] = useState([
    {judul:'Pencairan BLT Provinsi — Juni 2025', tanggal:'1 Jun 2025', status:'Aktif'},
    {judul:'Update Data DTKS — Semester I 2025', tanggal:'15 Mei 2025', status:'Aktif'},
    {judul:'Informasi PKH Tahap 2 2025', tanggal:'10 Apr 2025', status:'Selesai'},
  ])

  return (
    <div className="p-6">
      <PageHeader title="Info Bansos" subtitle="Sinkronisasi data penerima bantuan sosial" />
      <Tabs tabs={[{key:'sinkron',label:'Sinkronisasi Data'},{key:'pengumuman',label:'Pengumuman'}]} active={tab} onChange={setTab} />

      {tab === 'sinkron' && (
        <div className="card p-6 max-w-2xl">
          <div className="flex items-center gap-4 mb-6">
            <div className="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center"><span className="text-2xl">🔄</span></div>
            <div>
              <p className="font-bold text-gray-800">Sinkronisasi DTKS</p>
              <p className="text-sm text-gray-500">Terakhir sinkron: Hari ini, 06:00 WIB</p>
            </div>
          </div>
          <div className="grid grid-cols-3 gap-4 mb-6">
            {[['1.248.320','Total Penerima','#1565C0'],['423.100','PKH','#2E7D32'],['825.220','BPNT','#F57F17']].map(([v,l,c])=>(
              <div key={l} className="text-center p-3 bg-gray-50 rounded-xl">
                <p className="text-xl font-bold" style={{color:c}}>{v}</p>
                <p className="text-xs text-gray-500">{l}</p>
              </div>
            ))}
          </div>
          <div className="flex gap-3">
            <Button variant="outline" icon={Plus}>Upload CSV DTKS Terbaru</Button>
            <Button onClick={()=>alert('Sinkronisasi dimulai...')}>Mulai Sinkronisasi API</Button>
          </div>
        </div>
      )}

      {tab === 'pengumuman' && (
        <>
          <div className="flex justify-end mb-4">
            <Button icon={Plus}>Buat Pengumuman</Button>
          </div>
          <div className="space-y-3">
            {pengumuman.map((p,i)=>(
              <div key={i} className="card p-4 flex items-center gap-4">
                <div className="flex-1">
                  <p className="font-semibold text-gray-800">{p.judul}</p>
                  <p className="text-sm text-gray-500">{p.tanggal}</p>
                </div>
                <Badge label={p.status} type={p.status==='Aktif'?'success':'neutral'} />
                <button onClick={()=>setPengumuman(pengumuman.filter((_,j)=>j!==i))} className="text-red-400"><Trash2 size={14}/></button>
              </div>
            ))}
          </div>
        </>
      )}
    </div>
  )
}

// ─── E-TIBI ───────────────────────────────────────────────────────────────────
export function Etibi() {
  const pasien = [
    {nama:'Budi Santoso', fase:'Intensif Bulan 2', kepatuhan:'65%', status:'Mangkir'},
    {nama:'Siti Aminah', fase:'Lanjutan Bulan 4', kepatuhan:'40%', status:'Mangkir'},
    {nama:'Ahmad Farhan', fase:'Intensif Bulan 1', kepatuhan:'90%', status:'Patuh'},
    {nama:'Rina Wati', fase:'Lanjutan Bulan 5', kepatuhan:'95%', status:'Patuh'},
    {nama:'Dodi Kurnia', fase:'Intensif Bulan 3', kepatuhan:'78%', status:'Patuh'},
  ]

  return (
    <div className="p-6">
      <PageHeader title="Skrining E-Tibi" subtitle="Pemantauan kepatuhan pasien TBC" />
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        {[['847','Pasien Aktif','#00838F'],['23','Peringatan Mangkir','#C62828'],['82%','Kepatuhan Rata-rata','#2E7D32'],['124','Selesai Terapi','#1565C0']].map(([v,l,c])=>(
          <div key={l} className="card p-4" style={{borderLeft:`4px solid ${c}`}}>
            <p className="text-2xl font-bold" style={{color:c}}>{v}</p>
            <p className="text-xs text-gray-500 mt-1">{l}</p>
          </div>
        ))}
      </div>
      <div className="space-y-3">
        {pasien.map((p,i)=>(
          <div key={i} className={`card p-4 flex items-center gap-4 ${p.status==='Mangkir'?'border-red-300':''}`}>
            <div className={`w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0 ${p.status==='Mangkir'?'bg-red-100':'bg-green-100'}`}>
              <span className="font-bold text-sm" style={{color:p.status==='Mangkir'?'#C62828':'#2E7D32'}}>{p.nama[0]}</span>
            </div>
            <div className="flex-1">
              <p className="font-semibold text-gray-800">{p.nama}</p>
              <p className="text-sm text-gray-500">Fase: {p.fase} • Kepatuhan: {p.kepatuhan}</p>
            </div>
            <div className="text-right">
              <Badge label={p.status} type={p.status==='Mangkir'?'danger':'success'} />
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}

// ─── SINAKER ──────────────────────────────────────────────────────────────────
export function Sinaker() {
  const [tab, setTab] = useState('lowongan')
  const [lowongan] = useState([
    {judul:'Flutter Developer', perusahaan:'PT Teknologi Nusantara', lokasi:'Surabaya', gaji:'8-12 Jt', pelamar:'47', status:'Aktif'},
    {judul:'Data Analyst', perusahaan:'PT Astra Agro', lokasi:'Malang', gaji:'7-10 Jt', pelamar:'92', status:'Aktif'},
    {judul:'UI/UX Designer', perusahaan:'CV Kreatif Jatim', lokasi:'Sidoarjo', gaji:'6-9 Jt', pelamar:'35', status:'Ditutup'},
    {judul:'Backend Engineer', perusahaan:'PT Digital Raya', lokasi:'Surabaya', gaji:'10-15 Jt', pelamar:'28', status:'Aktif'},
  ])
  const [kandidat] = useState([
    {nama:'Fahmi Rachman', posisi:'Flutter Developer', tanggal:'2 Jun 2025', status:'Interview'},
    {nama:'Dewi Lestari', posisi:'Data Analyst', tanggal:'1 Jun 2025', status:'Review'},
    {nama:'Andi Kurniawan', posisi:'Flutter Developer', tanggal:'31 Mei 2025', status:'Diterima'},
    {nama:'Maya Putri', posisi:'UI/UX Designer', tanggal:'30 Mei 2025', status:'Ditolak'},
  ])

  const statusType = s => ({Diterima:'success',Ditolak:'danger',Interview:'info',Review:'warning'}[s]||'neutral')

  return (
    <div className="p-6">
      <PageHeader title="Sinaker" subtitle="Kelola lowongan kerja dan pelamar"
        actions={<Button icon={Plus}>Posting Lowongan</Button>} />
      <Tabs tabs={[{key:'lowongan',label:'Lowongan Aktif'},{key:'kandidat',label:'Kandidat Pelamar'}]} active={tab} onChange={setTab} />

      {tab === 'lowongan' && (
        <Table
          columns={[
            {header:'Posisi', key:'judul', render:r=><span className="font-semibold">{r.judul}</span>},
            {header:'Perusahaan', key:'perusahaan'},
            {header:'Lokasi', key:'lokasi'},
            {header:'Gaji', key:'gaji', render:r=><span className="font-semibold text-green-600">Rp {r.gaji}</span>},
            {header:'Pelamar', key:'pelamar', render:r=><Badge label={`${r.pelamar} pelamar`} type="info"/>},
            {header:'Status', key:'status', render:r=><Badge label={r.status} type={r.status==='Aktif'?'success':'neutral'}/>},
          ]}
          data={lowongan}
        />
      )}

      {tab === 'kandidat' && (
        <div className="space-y-3">
          {kandidat.map((k,i)=>(
            <div key={i} className="card p-4 flex items-center gap-4">
              <div className="w-10 h-10 bg-blue-100 rounded-xl flex items-center justify-center font-bold text-blue-600 flex-shrink-0">
                {k.nama[0]}
              </div>
              <div className="flex-1">
                <p className="font-semibold text-gray-800">{k.nama}</p>
                <p className="text-sm text-gray-500">Melamar: {k.posisi} • {k.tanggal}</p>
              </div>
              <Badge label={k.status} type={statusType(k.status)} />
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

// ─── TRANSJATIM ───────────────────────────────────────────────────────────────
export function Transjatim() {
  const armada = [
    {plat:'B 7001 TJ', koridor:'Koridor 1 — Purabaya–Rajawali', halte:'Halte Wonokromo', status:'Beroperasi', penumpang:42},
    {plat:'B 7015 TJ', koridor:'Koridor 2 — MERR', halte:'Halte ITS', status:'Beroperasi', penumpang:38},
    {plat:'B 7023 TJ', koridor:'Koridor 3 — Bunder', halte:'Halte Rungkut', status:'Beroperasi', penumpang:55},
    {plat:'B 7030 TJ', koridor:'Koridor 1', halte:'Depo Surabaya', status:'Tidak Beroperasi', penumpang:0},
  ]

  return (
    <div className="p-6">
      <PageHeader title="Transjatim" subtitle="Dashboard armada bus dan tiket digital" />
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        {[['34','Armada Beroperasi','#558B2F'],['2.841','Tiket Terjual','#1565C0'],['14.290','Total Penumpang','#00838F'],['8','Koridor Aktif','#F57F17']].map(([v,l,c])=>(
          <div key={l} className="card p-4">
            <p className="text-2xl font-bold" style={{color:c}}>{v}</p>
            <p className="text-xs text-gray-500 mt-1">{l}</p>
          </div>
        ))}
      </div>

      <div className="card overflow-hidden mb-6">
        <div className="px-4 py-3 bg-gray-50 border-b font-semibold text-sm text-gray-700">Status Armada Real-Time</div>
        <div className="divide-y divide-gray-100">
          {armada.map((a,i)=>(
            <div key={i} className="flex items-center gap-4 px-4 py-3">
              <div className={`w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0 ${a.status==='Beroperasi'?'bg-green-100':'bg-red-100'}`}>
                <Bus size={18} color={a.status==='Beroperasi'?'#2E7D32':'#C62828'} />
              </div>
              <div className="flex-1">
                <p className="font-semibold text-sm text-gray-800">{a.plat}</p>
                <p className="text-xs text-gray-500">{a.koridor} • {a.halte}</p>
              </div>
              {a.penumpang > 0 && <span className="text-xs text-gray-500">{a.penumpang} penumpang</span>}
              <Badge label={a.status} type={a.status==='Beroperasi'?'success':'danger'} />
            </div>
          ))}
        </div>
      </div>

      <div className="card p-8 flex flex-col items-center justify-center text-center bg-blue-50 border-blue-200">
        <span className="text-5xl mb-4">🗺️</span>
        <p className="font-bold text-gray-800 text-lg">Fleet Management Map</p>
        <p className="text-sm text-gray-500 mt-1">Integrasi Google Maps / Mapbox diperlukan untuk tampilan peta armada real-time</p>
      </div>
    </div>
  )
}
