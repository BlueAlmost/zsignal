//waveforms
pub const sin_wave = @import("src/waveforms.zig").sin_wave;
pub const cos_wave = @import("src/waveforms.zig").cos_wave;
pub const exp_wave = @import("src/waveforms.zig").exp_wave;

// windows
pub const bartlett = @import("src/bartlett.zig").bartlett;
pub const blackman = @import("src/blackman.zig").blackman;
pub const bohman = @import("src/bohman.zig").bohman;
pub const blackmanharris = @import("src/blackmanharris.zig").blackmanharris;
// pub const chebywin    = @import("src/chebywin.zig").chebywin;
pub const gausswin = @import("src/gausswin.zig").gausswin;
pub const hamming = @import("src/hamming.zig").hamming;
pub const hann = @import("src/hann.zig").hann;
pub const nuttall = @import("src/nuttall.zig").nuttall;
pub const parzen = @import("src/parzen.zig").parzen;
pub const triang = @import("src/triang.zig").triang;
pub const tukeywin = @import("src/tukeywin.zig").tukeywin;

// freqz
// fft
// sinc

