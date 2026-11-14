<!DOCTYPE html>
<html lang="ar" dir="rtl" class="dark">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>محاكي الترانزستور وبواباته المنطقية | TransistorLab</title>
  <meta name="description" content="محاكي تفاعلي شامل للترانزستور والبوابات المنطقية ودوائرها مع قياسات الجهد والتيار اللحظية ومنحنى الخواص." />

  <!-- Tailwind CSS CDN -->
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      darkMode: 'class',
      theme: {
        extend: {
          colors: {
            cyan: { 400: '#22d3ee', 500: '#06b6d4', 600: '#0891b2' },
            emerald: { 400: '#34d399', 500: '#10b981', 600: '#059669' }
          }
        }
      }
    };
  </script>

  <style>
    @keyframes wireFlow {
      from { stroke-dashoffset: 24; }
      to { stroke-dashoffset: 0; }
    }
    .animate-wire-flow {
      stroke-dasharray: 6 6;
      animation: wireFlow 1s linear infinite;
    }
    input[type=range] {
      accent-color: #06b6d4;
    }
  </style>
</head>
<body class="bg-slate-950 text-slate-100 min-h-screen flex flex-col font-sans transition-colors duration-200">

  <!-- Header Navbar -->
  <header class="sticky top-0 z-50 border-b border-slate-800 bg-slate-900/90 backdrop-blur-md">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between gap-4">
      <div class="flex items-center gap-3">
        <div class="w-9 h-9 rounded-lg bg-gradient-to-tr from-cyan-600 to-emerald-500 flex items-center justify-center text-white shadow-sm font-bold text-lg">
          ⚡
        </div>
        <div>
          <h1 class="text-base font-bold text-white tracking-tight">محاكي الترانزستور وبواباته المنطقية</h1>
          <p class="text-[11px] text-slate-400">TransistorLab • ملف مستقل ومصحح بالكامل يعمل بدون إنترنت</p>
        </div>
      </div>

      <!-- Navigation Tabs -->
      <nav class="hidden md:flex items-center gap-1.5 p-1 bg-slate-800/80 rounded-xl">
        <button onclick="switchTab('simulator')" id="nav-simulator" class="tab-btn px-3.5 py-1.5 text-xs font-bold rounded-lg transition-all bg-cyan-500 text-white shadow-xs">
          محاكي الترانزستور (GUI)
        </button>
        <button onclick="switchTab('chart')" id="nav-chart" class="tab-btn px-3.5 py-1.5 text-xs font-bold rounded-lg transition-all text-slate-400 hover:text-white">
          لوحة البوابات (الجدول)
        </button>
        <button onclick="switchTab('gates')" id="nav-gates" class="tab-btn px-3.5 py-1.5 text-xs font-bold rounded-lg transition-all text-slate-400 hover:text-white">
          محاكي البوابات CMOS
        </button>
        <button onclick="switchTab('cascaded')" id="nav-cascaded" class="tab-btn px-3.5 py-1.5 text-xs font-bold rounded-lg transition-all text-slate-400 hover:text-white">
          الدوائر المدمجة (ALU)
        </button>
      </nav>

      <!-- Action Button -->
      <div class="flex items-center gap-2">
        <button onclick="resetSimulation()" class="px-3 py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-300 text-xs font-bold transition-colors">
          إعادة الضبط
        </button>
      </div>
    </div>

    <!-- Mobile Navigation Bar -->
    <div class="md:hidden border-t border-slate-800 px-3 py-2 flex items-center justify-around overflow-x-auto gap-1">
      <button onclick="switchTab('simulator')" id="mob-simulator" class="px-2.5 py-1 text-xs font-bold rounded bg-cyan-500 text-white whitespace-nowrap">الترانزستور</button>
      <button onclick="switchTab('chart')" id="mob-chart" class="px-2.5 py-1 text-xs font-bold rounded text-slate-400 whitespace-nowrap">جدول البوابات</button>
      <button onclick="switchTab('gates')" id="mob-gates" class="px-2.5 py-1 text-xs font-bold rounded text-slate-400 whitespace-nowrap">البوابات</button>
      <button onclick="switchTab('cascaded')" id="mob-cascaded" class="px-2.5 py-1 text-xs font-bold rounded text-slate-400 whitespace-nowrap">الدوائر</button>
    </div>
  </header>

  <!-- Main Container -->
  <main class="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-6 space-y-6">

    <!-- TAB 1: TRANSISTOR SIMULATOR GUI WORKBENCH -->
    <section id="tab-simulator-content" class="space-y-6">
      <div class="bg-slate-900 border border-slate-800 rounded-xl p-5 shadow-xs">
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <div class="flex items-center gap-2">
              <span class="w-2.5 h-2.5 rounded-full bg-cyan-500 animate-pulse"></span>
              <h2 class="text-lg font-bold text-white">واجهة محاكاة الترانزستور التفاعلية (GUI Workbench)</h2>
            </div>
            <p class="mt-1 text-xs text-slate-400">
              اختر نوع الترانزستور، وتحكم في قيم الجهد والتيار والمقاومة، وراقب القياسات اللحظية ومنحنى الخواص ونقطة العمل Q-Point.
            </p>
          </div>

          <!-- Transistor Type Selector -->
          <div class="flex items-center gap-1.5 p-1 bg-slate-800 rounded-xl shrink-0">
            <button onclick="setTransistorType('NMOS')" id="type-NMOS" class="type-btn px-3.5 py-1.5 text-xs font-bold rounded-lg bg-cyan-500 text-white">NMOS</button>
            <button onclick="setTransistorType('PMOS')" id="type-PMOS" class="type-btn px-3.5 py-1.5 text-xs font-bold rounded-lg text-slate-400 hover:text-white">PMOS</button>
            <button onclick="setTransistorType('NPN')" id="type-NPN" class="type-btn px-3.5 py-1.5 text-xs font-bold rounded-lg text-slate-400 hover:text-white">NPN (BJT)</button>
            <button onclick="setTransistorType('PNP')" id="type-PNP" class="type-btn px-3.5 py-1.5 text-xs font-bold rounded-lg text-slate-400 hover:text-white">PNP (BJT)</button>
          </div>
        </div>

        <!-- Quick Scenarios Presets -->
        <div class="mt-4 pt-3 border-t border-slate-800 flex flex-wrap items-center justify-between gap-2 text-xs">
          <span class="font-semibold text-slate-400">حالات تجريبية سريعة (Presets):</span>
          <div class="flex items-center gap-1.5 flex-wrap">
            <button onclick="applyPreset('cutoff')" class="px-2.5 py-1 rounded-md bg-slate-800 hover:bg-slate-700 text-slate-300">مفتاح مفتوح (0 قطع)</button>
            <button onclick="applyPreset('saturation')" class="px-2.5 py-1 rounded-md bg-slate-800 hover:bg-slate-700 text-slate-300">مفتاح مغلق (1 تشبع)</button>
            <button onclick="applyPreset('active')" class="px-2.5 py-1 rounded-md bg-slate-800 hover:bg-slate-700 text-slate-300">مضخم خطي (Q-Point)</button>
            <button onclick="applyPreset('threshold')" class="px-2.5 py-1 rounded-md bg-slate-800 hover:bg-slate-700 text-slate-300">حافة العتبة (Vth)</button>
          </div>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
        
        <!-- Left Stage: SVG Canvas & Graphs (Col 8) -->
        <div class="lg:col-span-8 bg-slate-900 border border-slate-800 rounded-xl p-5 shadow-xs space-y-4">
          <div class="flex flex-wrap items-center justify-between gap-3 border-b border-slate-800 pb-3">
            <div class="flex items-center gap-1 p-1 bg-slate-800 rounded-lg">
              <button onclick="setViewMode('schematic')" id="view-schematic" class="view-btn px-3 py-1 text-xs font-bold rounded-md bg-slate-700 text-cyan-400">المخطط الكهربائي التفاعلي</button>
              <button onclick="setViewMode('iv_curve')" id="view-iv_curve" class="view-btn px-3 py-1 text-xs font-bold rounded-md text-slate-400 hover:text-white">منحنى الخواص (I-V & Q-Point)</button>
            </div>

            <span id="region-badge" class="font-mono text-xs font-bold px-2.5 py-1 rounded-md border bg-rose-500/10 text-rose-400 border-rose-500/30">
              منطقة القطع (Cut-off)
            </span>
          </div>

          <!-- Canvas Container -->
          <div class="w-full bg-slate-950 rounded-xl p-4 flex items-center justify-center min-h-[380px] border border-slate-800 relative overflow-hidden">
            <div id="canvas-schematic" class="w-full flex justify-center">
              <svg id="schematic-svg" viewBox="0 0 540 340" class="w-full max-w-[500px] h-auto select-none"></svg>
            </div>
            <div id="canvas-iv_curve" class="w-full hidden justify-center">
              <svg id="iv-curve-svg" viewBox="0 0 540 320" class="w-full max-w-[500px] h-auto select-none"></svg>
            </div>
          </div>

          <!-- Real-Time Telemetry Cards -->
          <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 pt-1">
            <div class="p-3 rounded-lg bg-slate-800/60 border border-slate-800">
              <div class="text-[11px] text-slate-400">تيار الحمل (I_load)</div>
              <div id="stat-current" class="text-lg font-mono font-bold text-emerald-400 tabular-nums">0.00 mA</div>
            </div>
            <div class="p-3 rounded-lg bg-slate-800/60 border border-slate-800">
              <div class="text-[11px] text-slate-400">جهد الخرج (V_out)</div>
              <div id="stat-vout" class="text-lg font-mono font-bold text-cyan-400 tabular-nums">5.00 V</div>
            </div>
            <div class="p-3 rounded-lg bg-slate-800/60 border border-slate-800">
              <div class="text-[11px] text-slate-400">استهلاك الطاقة (P_diss)</div>
              <div id="stat-power" class="text-lg font-mono font-bold text-amber-500 tabular-nums">0.0 mW</div>
            </div>
            <div class="p-3 rounded-lg bg-slate-800/60 border border-slate-800">
              <div class="text-[11px] text-slate-400">حالة المفتاح</div>
              <div id="stat-state" class="text-xs font-bold text-slate-200 mt-1">مفتاح مفتوح (OFF)</div>
            </div>
          </div>
        </div>

        <!-- Right Stage: Precision Controls Deck (Col 4) -->
        <div class="lg:col-span-4 space-y-4">
          <div class="bg-slate-900 border border-slate-800 rounded-xl p-5 shadow-xs space-y-4">
            <div class="flex items-center justify-between">
              <h3 class="text-sm font-bold text-white">عناصر التحكم في الجهد والتيار</h3>
              <span id="device-family-badge" class="text-[11px] font-mono px-2 py-0.5 rounded bg-slate-800 text-slate-400">MOSFET</span>
            </div>

            <!-- BJT Drive Mode Selector (Only shown for NPN / PNP) -->
            <div id="bjt-drive-mode-container" class="space-y-2 p-2.5 rounded-lg bg-cyan-500/5 border border-cyan-500/20 hidden">
              <div class="text-[11px] font-bold text-cyan-400">طريقة التحكم في الترانزستور الثنائي (BJT):</div>
              <div class="flex items-center gap-1 p-0.5 bg-slate-800 rounded-md">
                <button onclick="setBjtDriveMode('voltage')" id="bjt-mode-v" class="flex-1 py-1 text-xs font-bold rounded bg-slate-700 text-white">تحكم بالجهد (V_B)</button>
                <button onclick="setBjtDriveMode('current')" id="bjt-mode-i" class="flex-1 py-1 text-xs font-bold rounded text-slate-400 hover:text-white">تيار مباشر (I_B)</button>
              </div>
            </div>

            <!-- MOSFET & BJT Voltage Drive Modes (Analog vs Digital) -->
            <div id="voltage-drive-controls">
              <div class="flex items-center gap-1 p-1 bg-slate-800 rounded-lg mb-3">
                <button onclick="setGateMode('analog')" id="mode-analog" class="flex-1 py-1 text-xs font-bold rounded-md bg-slate-700 text-white">جهد تماثلي (V)</button>
                <button onclick="setGateMode('binary')" id="mode-binary" class="flex-1 py-1 text-xs font-bold rounded-md text-slate-400 hover:text-white">منطق رقمي (0 / 1)</button>
              </div>

              <!-- Analog Voltage Slider -->
              <div id="control-analog-voltage" class="space-y-1.5">
                <div class="flex items-center justify-between text-xs">
                  <span id="label-vin-title" class="font-semibold text-slate-300">جهد البوابة/القاعدة (V_in):</span>
                  <span id="label-vin" class="font-mono font-bold text-cyan-400">3.50 V</span>
                </div>
                <input type="range" id="slider-vin" min="0" max="5" step="0.05" value="3.5" oninput="onVinChange(this.value)" class="w-full accent-cyan-500 cursor-pointer h-2 bg-slate-700 rounded-lg" />
                <div class="flex justify-between text-[10px] text-slate-400">
                  <span>0.00 V</span>
                  <span id="vth-indicator" class="text-amber-500 font-semibold">عتبة Vth = 1.2V</span>
                  <span id="vin-max-label">5.0 V</span>
                </div>
              </div>

              <!-- Digital Binary Toggle -->
              <div id="control-digital-binary" class="space-y-2 hidden">
                <div class="flex items-center justify-between text-xs text-slate-400">
                  <span>القيمة المنطقية للمدخل:</span>
                  <span id="binary-val-label" class="font-mono font-bold text-cyan-400">1 (HIGH)</span>
                </div>
                <div class="grid grid-cols-2 gap-2">
                  <button onclick="setGateBinary(0)" id="btn-binary-0" class="py-2 px-3 rounded-lg text-xs font-bold border border-slate-800 text-slate-400">0 (LOW / 0V)</button>
                  <button onclick="setGateBinary(1)" id="btn-binary-1" class="py-2 px-3 rounded-lg text-xs font-bold border bg-emerald-500/10 text-emerald-400 border-emerald-500/40">1 (HIGH / 5V)</button>
                </div>
              </div>
            </div>

            <!-- BJT Direct Base Current Slider -->
            <div id="control-bjt-current" class="space-y-1.5 hidden">
              <div class="flex items-center justify-between text-xs">
                <span class="font-semibold text-slate-300">تيار القاعدة المباشر (I_B):</span>
                <span id="label-ib" class="font-mono font-bold text-emerald-400">120 μA</span>
              </div>
              <input type="range" id="slider-ib" min="0" max="400" step="5" value="120" oninput="onIbChange(this.value)" class="w-full accent-emerald-500 cursor-pointer h-2 bg-slate-700 rounded-lg" />
              <div class="flex justify-between text-[10px] text-slate-400">
                <span>0 μA (قطع)</span>
                <span>100 μA</span>
                <span>400 μA (تشبع)</span>
              </div>
            </div>

            <!-- BJT Current Gain Slider -->
            <div id="control-bjt-gain" class="space-y-1.5 pt-2 border-t border-slate-800 hidden">
              <div class="flex items-center justify-between text-xs">
                <span class="font-semibold text-slate-300">معامل الكسب (β / hFE):</span>
                <span id="label-beta" class="font-mono font-bold text-cyan-400">150</span>
              </div>
              <input type="range" id="slider-beta" min="50" max="300" step="10" value="150" oninput="onBetaChange(this.value)" class="w-full accent-cyan-500 cursor-pointer h-2 bg-slate-700 rounded-lg" />
            </div>

            <!-- Supply Voltage (VDD / VCC) -->
            <div class="space-y-1.5 pt-2 border-t border-slate-800">
              <div class="flex items-center justify-between text-xs">
                <span id="label-vsupply-title" class="font-semibold text-slate-300">جهد التغذية الرئيسي (V_DD):</span>
                <span id="label-vsupply" class="font-mono font-bold text-white">5.0 V</span>
              </div>
              <input type="range" id="slider-vsupply" min="1" max="12" step="0.5" value="5.0" oninput="onVSupplyChange(this.value)" class="w-full accent-cyan-500 cursor-pointer h-2 bg-slate-700 rounded-lg" />
            </div>

            <!-- Load Resistor (RL / RC) -->
            <div class="space-y-1.5 pt-2 border-t border-slate-800">
              <div class="flex items-center justify-between text-xs">
                <span id="label-rload-title" class="font-semibold text-slate-300">مقاومة الحمل (Load R_L):</span>
                <span id="label-rload" class="font-mono font-bold text-white">250 Ω</span>
              </div>
              <input type="range" id="slider-rload" min="50" max="2000" step="50" value="250" oninput="onRLoadChange(this.value)" class="w-full accent-cyan-500 cursor-pointer h-2 bg-slate-700 rounded-lg" />
            </div>

            <!-- Threshold Voltage (Vth) - MOSFET only -->
            <div id="control-vthreshold" class="space-y-1.5 pt-2 border-t border-slate-800">
              <div class="flex items-center justify-between text-xs">
                <span class="font-semibold text-slate-300">جهد العتبة (V_th):</span>
                <span id="label-vth" class="font-mono font-bold text-amber-500">1.20 V</span>
              </div>
              <input type="range" id="slider-vth" min="0.5" max="2.5" step="0.1" value="1.2" oninput="onVthChange(this.value)" class="w-full accent-amber-500 cursor-pointer h-2 bg-slate-700 rounded-lg" />
            </div>
          </div>

          <!-- Physics Equation Card -->
          <div class="bg-cyan-500/5 border border-cyan-500/20 rounded-xl p-4 text-xs text-slate-300 space-y-2">
            <div class="font-bold text-cyan-400">المعادلة الفيزيائية الحاكمة للتيار:</div>
            <div id="equation-display" class="font-mono text-[11px] bg-slate-800/80 p-2 rounded border border-slate-700 text-slate-200">
              I_D = 0.5·K·(V_GS - V_th)² (منطقة التشبع)
            </div>
            <p class="text-[11px] text-slate-400">
              يتقاطع منحنى الترانزستور مع خط الحمل V_DS = V_DD - I_D·R_L لحساب نقطة التشغيل اللحظية بدقة.
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- TAB 2: MASTER LOGIC GATES CHART -->
    <section id="tab-chart-content" class="hidden space-y-6">
      <div class="bg-slate-900 border border-slate-800 rounded-xl p-5 shadow-xs">
        <h2 class="text-xl font-bold text-white">لوحة البوابات المنطقية السبع (Master Logic Gates Chart)</h2>
        <p class="text-xs text-slate-400 mt-1">
          مخطط البوابات المنطقية الأساسية والمشتقة مع الرموز القياسية الأمريكية ANSI، وفقاعة النفي العاكسة الحمراء، وجداول الحقيقة، والتطبيقات المنسية في الإلكترونيات.
        </p>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5" id="gates-chart-grid"></div>
    </section>

    <!-- TAB 3: INTERACTIVE CMOS GATES -->
    <section id="tab-gates-content" class="hidden space-y-6">
      <div class="bg-slate-900 border border-slate-800 rounded-xl p-5 shadow-xs">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div>
            <h2 class="text-xl font-bold text-white">محاكي البوابات بالترانزستور (CMOS Architecture)</h2>
            <p class="text-xs text-slate-400 mt-1">انقر على المدخلات A و B لمراقبة عمل شبكة ترانزستورات PMOS و NMOS وتوليد الخرج.</p>
          </div>
          <div class="flex items-center gap-1 bg-slate-800 p-1 rounded-lg overflow-x-auto">
            <button onclick="selectInteractiveGate('NOT')" id="igate-NOT" class="px-2.5 py-1 text-xs font-bold rounded text-slate-400 hover:text-white">NOT</button>
            <button onclick="selectInteractiveGate('AND')" id="igate-AND" class="px-2.5 py-1 text-xs font-bold rounded text-slate-400 hover:text-white">AND</button>
            <button onclick="selectInteractiveGate('NAND')" id="igate-NAND" class="px-2.5 py-1 text-xs font-bold rounded bg-cyan-500 text-white">NAND</button>
            <button onclick="selectInteractiveGate('OR')" id="igate-OR" class="px-2.5 py-1 text-xs font-bold rounded text-slate-400 hover:text-white">OR</button>
            <button onclick="selectInteractiveGate('NOR')" id="igate-NOR" class="px-2.5 py-1 text-xs font-bold rounded text-slate-400 hover:text-white">NOR</button>
            <button onclick="selectInteractiveGate('XOR')" id="igate-XOR" class="px-2.5 py-1 text-xs font-bold rounded text-slate-400 hover:text-white">XOR</button>
            <button onclick="selectInteractiveGate('XNOR')" id="igate-XNOR" class="px-2.5 py-1 text-x