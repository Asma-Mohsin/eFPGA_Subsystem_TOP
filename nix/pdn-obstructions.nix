{
  buildPythonPackage,
  librelane,
  setuptools,
}:
buildPythonPackage {
  pname = "librelane-pdn-obstructions";
  version = "0.1.0";
  pyproject = true;
  src = ../librelane_pdn_obstructions;

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [ librelane ];

  includedTools = [ ];
  doCheck = false;
}