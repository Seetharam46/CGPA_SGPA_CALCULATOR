const SEMESTERS = ['1-1', '1-2', '2-1', '2-2', '3-1', '3-2', '4-1', '4-2'];
const GRADES = [
  { label: 'A+', value: 10 }, { label: 'A', value: 9 },
  { label: 'B', value: 8 }, { label: 'C', value: 7 },
  { label: 'D', value: 6 }, { label: 'E', value: 5 }, { label: 'F', value: 0 }
];
const CREDIT_OPTIONS = [3, 2, 1.5];
let state = { users: [], user: null, data: {} };

function promptForFirstUser() {
  const modal = document.getElementById('userEntryModal');
  const form = modal.querySelector('form');
  const input = document.getElementById('entryUsername');
  const err = document.getElementById('entryError');
  function open() {
    modal.classList.remove('hidden');
    document.body.classList.add('modal-open');
    input.value = '';
    err.textContent = '';
    setTimeout(()=>input.focus(),30);
  }
  function close() {
    modal.classList.add('hidden');
    document.body.classList.remove('modal-open');
  }
  form.onsubmit = e => {
    e.preventDefault();
    let val = input.value.trim();
    if (!val) { err.textContent = "Please enter a username."; return;}
    if (val.length > 18) { err.textContent = "Max 18 chars."; return;}
    if (state.users.includes(val)) { err.textContent = "User already exists."; return;}
    state.users.push(val);
    state.data[val] = {};
    state.user = val;
    saveState();
    close();
    renderUserDropdown();
    renderSemesters();
    renderCgpa();
    showToast("User Added!");
  };
  open();
}
function saveState() {
  localStorage.setItem('sgpaAppUsers', JSON.stringify(state.users));
  localStorage.setItem('sgpaAppData', JSON.stringify(state.data));
  localStorage.setItem('sgpaAppSelected', state.user);
}
function loadState() {
  state.users = JSON.parse(localStorage.getItem('sgpaAppUsers')) || [];
  state.data = JSON.parse(localStorage.getItem('sgpaAppData')) || {};
  state.user = localStorage.getItem('sgpaAppSelected') || null;
}
function showToast(msg) {
  const toast = document.getElementById('toast');
  toast.textContent = msg;
  toast.classList.add('show');
  setTimeout(() => toast.classList.remove('show'), 1200);
}
function renderUserDropdown() {
  const sel = document.getElementById('userSelect');
  sel.innerHTML = '';
  state.users.forEach(user => {
    const option = document.createElement('option');
    option.value = user;
    option.textContent = user;
    sel.appendChild(option);
  });
  sel.value = state.user || '';
}
function newUser() {
  const username = prompt("Enter new username:");
  if (!username || state.users.includes(username)) return;
  state.users.push(username);
  state.data[username] = {};
  state.user = username;
  saveState();
  renderUserDropdown();
  renderSemesters();
  renderCgpa();
  showToast("User Added!");
}
function deleteUser() {
  if (!state.user) return;
  if (!confirm(`Delete user "${state.user}"? This cannot be undone.`)) return;
  state.users.splice(state.users.indexOf(state.user), 1);
  delete state.data[state.user];
  state.user = state.users[0] || null;
  saveState();
  renderUserDropdown();
  renderSemesters();
  renderCgpa();
  showToast("User Deleted!");
}
function switchUser(e) {
  state.user = e.target.value;
  saveState();
  renderSemesters();
  renderCgpa();
  showToast("Switched to " + state.user);
}

function renderSemesters() {
  const container = document.getElementById('semesters');
  container.innerHTML = '';
  if (!state.user) {
    container.innerHTML =
      '<div style="grid-column:1/-1; padding:2em 0; text-align:center; color:#888;">Please add a user!</div>';
    renderCgpa();
    return;
  }
  SEMESTERS.forEach((sem, idx) => {
    const card = document.createElement('div');
    card.className = 'semCard';
    card.tabIndex = 0;
    card.textContent = sem;
    card.onclick = () => openSemester(idx);
    card.onkeyup = e => { if (e.key==="Enter"||e.key===" ") openSemester(idx);}
    container.appendChild(card);
  });
}

function openSemester(idx) {
  const modal = document.getElementById('modal');
  modal.classList.remove('hidden');
  document.getElementById('modalSemester').textContent = `Semester ${SEMESTERS[idx]}`;
  const semKey = "S" + (idx + 1);
  const userData = state.data[state.user] || {};
  const semData = userData[semKey] || { subjects: [] };
  const countInput = document.getElementById('subjectCount');
  countInput.value = semData.subjects.length || 9;
  renderSubjectRows(semData.subjects);
  updateSgpaOutputDisplay(semData);

  countInput.oninput = () => {
    renderSubjectRows();
    updateSgpaOutputDisplay(null);
  };

  document.getElementById('subjectForm').onsubmit = e => {
    e.preventDefault();
    saveSemester(idx);
    modal.classList.add('hidden');
  };
}

function closeModal() {
  document.getElementById('modal').classList.add('hidden');
}
document.getElementById('closeModal').onclick = closeModal;
document.getElementById('modal').onclick = e => {
  if (e.target.classList.contains('modal-overlay')) closeModal();
};

function renderSubjectRows(existing = []) {
  const count = Math.max(1, Math.min(15, parseInt(document.getElementById('subjectCount').value, 10) || 9));
  const container = document.getElementById('subjectRows');
  container.innerHTML = '';
  for (let i = 0; i < count; i++) {
    // Default: grade is A+ (10) unless already set
    const gradeSelected = (existing[i] && typeof existing[i].grade !== 'undefined' && existing[i].grade !== '') ? existing[i].grade : 10;
    const creditSelected = (existing[i] && typeof existing[i].credit !== 'undefined') ? existing[i].credit : 3;
    const row = document.createElement('div');
    row.className = 'subjectRow';
    row.innerHTML = `
      <label>Grade:
        <div class="select-wrap">
          <select class="gradeSel" required>
            <option value="" disabled${gradeSelected === '' ? ' selected' : ''}>Choose Grade</option>
            ${GRADES.map(g =>
              `<option value="${g.value}"${gradeSelected == g.value ? ' selected' : ''}>${g.label}</option>`
            ).join('')}
          </select>
          <span class="dropdown-arrow">&#9662;</span>
        </div>
      </label>
      <label>Credit:
        <div class="select-wrap">
          <select class="creditSel">
            ${CREDIT_OPTIONS.map(
              c => `<option value="${c}"${c == creditSelected ? ' selected' : ''}>${c}</option>`
            ).join('')}
          </select>
          <span class="dropdown-arrow">&#9662;</span>
        </div>
      </label>
    `;
    container.appendChild(row);
  }
}
function saveSemester(idx) {
  const semKey = "S" + (idx + 1);
  const subjectRows = document.querySelectorAll('#subjectRows .subjectRow');
  let subjects = [];
  let allValid = true;
  subjectRows.forEach(row => {
    const grade = row.querySelector('.gradeSel').value;
    const credit = parseFloat(row.querySelector('.creditSel').value);
    if (!grade) allValid = false;
    subjects.push({ grade: grade ? parseFloat(grade) : '', credit });
  });
  if (!allValid) {
    showToast("Select all grades!");
    return;
  }
  const totalCredits = subjects.reduce((sum, sub) => sum + (sub.grade !== '' ? sub.credit : 0), 0);
  const sgpa = totalCredits ? (subjects.reduce((sum, sub) => sum + (sub.grade !== '' ? sub.grade * sub.credit : 0), 0) / totalCredits) : null;
  if (!state.data[state.user]) state.data[state.user] = {};
  state.data[state.user][semKey] = { subjects, sgpa, totalCredits };
  saveState();
  renderCgpa();
  showToast("SGPA saved!");
}
function updateSgpaOutputDisplay(existingData) {
  const sgpaDiv = document.getElementById('sgpaOutput');
  let subjects = [];
  const subjectRows = document.querySelectorAll('#subjectRows .subjectRow');
  subjectRows.forEach(row => {
    const grade = row.querySelector('.gradeSel').value;
    const credit = parseFloat(row.querySelector('.creditSel').value);
    subjects.push({ grade: grade ? parseFloat(grade) : '', credit });
  });
  const valSubs = subjects.filter(sub => sub.grade !== '');
  const totalCredits = valSubs.reduce((sum, sub) => sum + sub.credit, 0);
  const sgpa = totalCredits ? (valSubs.reduce((sum, sub) => sum + sub.grade * sub.credit, 0) / totalCredits) : null;
  sgpaDiv.textContent = (sgpa != null && !isNaN(sgpa)) ? 'SGPA: ' + sgpa.toFixed(2) : '';
}
function renderCgpa() {
  const cgpaBar = document.getElementById('cgpaValue');
  if (!state.user) { cgpaBar.textContent = '--'; return;}
  const userData = state.data[state.user] || {};
  let numerator = 0, denominator = 0;
  for(let i=1; i<=8; i++) {
    const semKey = "S" + i;
    const sem = userData[semKey];
    if (sem && sem.sgpa && sem.totalCredits) {
      numerator += sem.sgpa * sem.totalCredits;
      denominator += sem.totalCredits;
    }
  }
  cgpaBar.textContent = denominator ? (numerator/denominator).toFixed(2) : '--';
}

document.getElementById('addUserBtn').onclick = newUser;
document.getElementById('deleteUserBtn').onclick = deleteUser;
document.getElementById('userSelect').onchange = switchUser;

loadState();
if (!state.users.length) {
  promptForFirstUser();
} else {
  renderUserDropdown();
  renderSemesters();
  renderCgpa();
}
