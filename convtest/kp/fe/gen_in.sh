# --- Script Settings ---
OUTPUT_FILE="ecut_convergence.dat"
# --- Cutoff values to test (in Ry) ---
KPS=(4 5 6 7 8 9 10 11 12)
# --- K-points for ecutwfc test (Keep fixed and reasonably dense) ---
ecut=90
# --- Create tmp directory if it doesn't exist ---
mkdir -p tmp
for kp in "${KPS[@]}"; do
ecutrho=$(( ecut * 12 ))
input_file="fe_kp_${kp}.in"
echo "  Running for ecutwfc = $ecut Ry, ecutrho = $ecutrho Ry..."
cat > ${input_file} << EOF
&CONTROL
  calculation = 'scf'
  etot_conv_thr =   3.6000000000d-04
  forc_conv_thr =   1.0000000000d-04
  outdir = './out/'
  prefix = 'fe-kp-${kp}'
  pseudo_dir = './pseudo/'
  tprnfor = .true.
  tstress = .true.
  verbosity = 'high'
/
&SYSTEM
  degauss =   2.0000000000d-02
  ecutrho =   ${ecutrho}
  ecutwfc =   ${ecut}
  ibrav = 0
  nat = 36
  nosym = .false.
  ntyp = 3
  occupations = 'smearing'
/
&ELECTRONS
  conv_thr =   7.2000000000d-09
  electron_maxstep = 80
  mixing_beta =   4.0000000000d-01
/
ATOMIC_SPECIES
Fe     55.845 Fe.pbesol-spn-kjpaw_psl.0.2.1.UPF
H      1.00794 H.pbesol-rrkjus_psl.1.0.0.UPF
Mg     24.305 Mg.pbesol-n-kjpaw_psl.0.3.0.UPF
ATOMIC_POSITIONS crystal
Mg           0.7500000000       0.7500000000       0.2500000000
Mg           0.7500000000       0.7500000000       0.7500000000
Mg           0.7500000000       0.2500000000       0.7500000000
Mg           0.7500000000       0.2500000000       0.2500000000
Mg           0.2500000000       0.7500000000       0.7500000000
Mg           0.2500000000       0.7500000000       0.2500000000
Mg           0.2500000000       0.2500000000       0.2500000000
Mg           0.2500000000       0.2500000000       0.7500000000
Fe           0.0000000000       0.0000000000       0.0000000000
Fe          -0.0000000000       0.5000000000       0.5000000000
Fe           0.5000000000       0.0000000000       0.5000000000
Fe           0.5000000000       0.5000000000       0.0000000000
H            0.0000000000       0.7570259700       0.0000000000
H            0.5000000000       0.0000000000       0.7429740300
H            0.5000000000       0.0000000000       0.2570259700
H            0.5000000000       0.7429740300       0.0000000000
H            0.7570259700       0.0000000000       0.0000000000
H            0.2429740300       0.0000000000       0.0000000000
H           -0.0000000000       0.2570259700       0.5000000000
H            0.5000000000       0.5000000000       0.2429740300
H            0.5000000000       0.5000000000       0.7570259700
H            0.5000000000       0.2429740300       0.5000000000
H            0.7570259700       0.5000000000       0.5000000000
H            0.2429740300       0.5000000000       0.5000000000
H            0.5000000000       0.7570259700       0.5000000000
H            0.0000000000       0.0000000000       0.2429740300
H            0.0000000000       0.0000000000       0.7570259700
H            0.0000000000       0.7429740300       0.5000000000
H            0.2570259700       0.0000000000       0.5000000000
H            0.7429740300       0.0000000000       0.5000000000
H            0.5000000000       0.2570259700      -0.0000000000
H           -0.0000000000       0.5000000000       0.7429740300
H           -0.0000000000       0.5000000000       0.2570259700
H            0.0000000000       0.2429740300       0.0000000000
H            0.2570259700       0.5000000000      -0.0000000000
H            0.7429740300       0.5000000000       0.0000000000
K_POINTS automatic
${kp} ${kp} ${kp} 0 0 0
CELL_PARAMETERS angstrom
      6.3550606530       0.0000000000       0.0000000000
      0.0000000000       6.3550606530       0.0000000000
      0.0000000000       0.0000000000       6.3550606530
EOF
done
