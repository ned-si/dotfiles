-- LilyPond, for drum sheets.
--
-- nvim-lilypond-suite brings a fast syntax file, async compilation via vim.uv
-- with errors routed into diagnostics and quickfix, and the MIDI player that was
-- never set up before.
--
-- Playback pipeline is: lilypond emits a .midi, midi_synth renders it to audio,
-- ffmpeg converts, mpv plays it in a floating window. timidity is the synth
-- rather than fluidsynth because fluidsynth needs a SoundFont supplied
-- separately and Homebrew ships none, whereas timidity bundles its own patches.
--
-- Scoped to lilypond only. The plugin also ships LaTeX and Texinfo ftplugins for
-- embedded scores, but those set makeprg for lilypond-book and would fight
-- vimtex over the compile loop.

return {
  {
    "martineausimon/nvim-lilypond-suite",
    ft = { "lilypond" },
    opts = {
      lilypond = {
        mappings = {
          player = "<localleader>p",
          compile = "<localleader>c",
          open_pdf = "<localleader>v",
          insert_version = "<localleader>i",
          hyphenation = "<localleader>h",
        },
        options = {
          output = "pdf",
          main_file = "main.ly",
        },
      },
      player = {
        options = {
          midi_synth = "timidity",
          audio_format = "wav", -- skip the mp3 encode; playback is local anyway
        },
      },
    },
  },
}
