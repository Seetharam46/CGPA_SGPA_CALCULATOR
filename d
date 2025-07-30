<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>SGPA & CGPA Calculator</title>
        <meta name="theme-color" content="#1665d8" />
        <link rel="manifest" href="manifest.json" />
        <link rel="icon" type="image/png" sizes="192x192" href="icon-192.png" />
        <link rel="stylesheet" href="style.css" />
    </head>
    <body>
        <div class="main-wrapper">
            <header>
                <h1 class="main-title">SGPA & CGPA Calculator</h1>
                <div class="user-controls">
                    <select id="userSelect"></select>
                    <button id="addUserBtn" class="plain-btn">Add User</button>
                    <button id="deleteUserBtn" class="plain-btn">Delete
                        User</button>
                </div>
            </header>

            <!-- Username modal, reused for Add User and first launch -->
            <div id="userEntryModal" class="entry-modal hidden">
                <form class="entry-form" autocomplete="off">
                    <div class="icon">&#128100;</div>
                    <input type="text" id="entryUsername" maxlength="18"
                        placeholder="Enter username" autofocus />
                    <button id="entryContinueBtn" type="submit">Start</button>
                    <button id="entryCancelBtn" type="button"
                        style="margin-left:1em;display:none;">Cancel</button>
                    <div id="entryError" class="entry-error"></div>
                </form>
            </div>

            <main>
                <div class="spacer-lg"></div>
                <div class="panel-flex">
                    <div class="grid-panel">
                        <div class="sem-grid-title">Semesters</div>
                        <section class="sem-grid" id="semesters"></section>
                    </div>
                </div>
                <button id="installBtn"
                    style="display:none;margin:1em auto;font-weight:600;font-size:.97em;padding:.58em 1.4em;border-radius:2em;background:#1665d8;color:#fff;border:none;cursor:pointer;">Install
                    App</button>
            </main>

            <div id="modal" class="modal-overlay hidden">
                <div class="modal">
                    <button id="closeModal" class="close-btn"
                        aria-label="Close">&times;</button>
                    <h2 id="modalSemester"></h2>
                    <form id="subjectForm" autocomplete="off">
                        <label>
                            Number of Subjects:
                            <input type="number" id="subjectCount" min="1"
                                max="15" value="9" autocomplete="off" />
                        </label>
                        <div id="subjectRows"></div>
                        <button type="submit" class="modal-save">Save
                            SGPA</button>
                    </form>
                    <div id="sgpaOutput"></div>
                </div>
            </div>

            <footer class="cgpa-banner">
                <span>CGPA:</span>
                <span id="cgpaValue">--</span>
            </footer>
            <div id="toast"></div>
        </div>
        <script src="script.js"></script>
        <script>
    // Service Worker for PWA
    if ('serviceWorker' in navigator) navigator.serviceWorker.register('sw.js');

    // PWA install button logic
    let deferredPrompt;
    window.addEventListener('beforeinstallprompt', (e) => {
      e.preventDefault();
      deferredPrompt = e;
      document.getElementById('installBtn').style.display = "block";
    });
    document.getElementById('installBtn').onclick = function() {
      if (deferredPrompt) {
        deferredPrompt.prompt();
        deferredPrompt.userChoice.then(() => { deferredPrompt = null; });
      }
      this.style.display = "none";
    };
  </script>
    </body>
</html>

:root {
--grad-bg: linear-gradient(135deg,#e3eefc 0%,#a7c5f8 60%,#fff 100%);
--white-glass: rgba(255,255,255,0.90);
--blue-glass: rgba(90,146,229,0.10);
--primary: #1665d8;
--primary-light: #478ae2;
--accent: #1976d2;
--danger: #e2574c;
--modal-bg: #f7faff;
--cgpa-glass: rgba(255,255,255,0.7);
--shadow: 0 8px 24px #1665d82b;
}
body {
background: var(--grad-bg); color: #174060;
min-height: 100vh; margin: 0; padding: 0;
font-family: 'Segoe UI', Verdana, Arial, sans-serif;
}
.main-wrapper { min-height: 100vh; max-width: 420px; margin: 0 auto;
display:flex; flex-direction:column;}
header {
padding: 1.2em 1em .7em 1em;
display: flex; flex-direction: column; align-items: center; background: none;
}
.main-title {
font-size: 1.34em;
font-weight: bold;
text-align: center;
color: var(--primary);
letter-spacing: 0.04em;
margin: 0 0 1.1em 0;
}
.spacer-lg { height: 1.3em; }
.user-controls {
display: flex;
align-items: center;
justify-content: center;
gap: 1.2em;
margin-top: 0.05em;
margin-bottom: 1.6em;
}
.user-controls select { margin-right: .1em; }
.plain-btn {
background: var(--primary-light);
color: #fff;
border: none;
border-radius: 2em;
padding: .45em 1.35em;
font-size: 1em;
font-weight: 600;
cursor: pointer;
transition: background .17s;
}
.plain-btn:hover { background: var(--accent);}
#userSelect {
border-radius: 2em;
border: 2px solid var(--primary);
font-size: 1em; padding: .38em 1em;
color: var(--primary); font-weight: 600; background: #fffefd;
outline: none; transition: border .17s;
}
#userSelect:focus { border-color: var(--accent);}
.sem-grid-title {
color: var(--primary);
font-size: 1.13em;
font-weight: bold;
letter-spacing:0.11em;
margin:.85em 0 .56em 1.19em;
user-select: none;
}
.sem-grid {
display: grid; grid-template-columns: repeat(4, 1fr);
gap: 1.03em 1.03em;
padding: 0 1.18em 1.1em 1.19em;
}
@media (max-width:600px) { .sem-grid { grid-template-columns: repeat(2,1fr);} }
.semCard {
background: var(--white-glass);
color: var(--primary);
border-radius: 1.2em;
font-size: 1.07em;
font-weight: 600;
text-align: center;
box-shadow: var(--shadow);
min-height: 42px;
min-width: 32px;
padding: .34em 0;
line-height: 1.7;
cursor: pointer;
user-select:none;
border:2px solid transparent;
transition: background .13s, color .13s, border .12s, transform .09s;
backdrop-filter: blur(7px);
margin-bottom: 0.12em;
}
.semCard:focus, .semCard:hover {
background: var(--blue-glass);
color: var(--primary-light); border:2px solid var(--accent); transform:
scale(1.08);
}
.cgpa-banner {
position: fixed; bottom:0; left:0; width: 100vw;
min-height: 50px; background: var(--cgpa-glass);
color: var(--primary); font-size: 1.08em; font-weight: bold;
letter-spacing:0.05em;
display: flex; justify-content: center; align-items: center; gap:.5em;
border-radius: 14px 14px 0 0; z-index: 100;
box-shadow: 0 1px 13px #1665d820; backdrop-filter: blur(4px);
}
.entry-modal {
position: fixed; top:0; left:0; width:100vw; height:100vh;
background: rgba(22,101,216,0.13);
display: flex; align-items: center; justify-content: center;
z-index: 9999; backdrop-filter: blur(6px);
}
.entry-form {
background: var(--white-glass); border-radius: 13px;
box-shadow: 0 2px 22px #1976d20c;
display: flex; flex-direction: column; align-items: center;
min-width: 140px; max-width: 90vw; padding: .8em 1.1em 1em 1.1em;
gap: .13em;
}
.icon { font-size: 2em; color: var(--primary); margin-bottom: .12em;}
.entry-form input[type="text"] {
margin: .55em 0 0 0; padding: .48em .95em; border-radius: 7px;
border: 1.3px solid #99c8fc; font-size: 1.02em; background: #f3f7fc;
outline: none; width: 145px; text-align: center;
}
.entry-form button {
margin-top: .15em; background: var(--primary);
color: #fff; border:none; border-radius: 1em;
font-size: .97em; padding: .36em 1.07em; font-weight: bold; cursor:pointer;
transition: background .2s;}
.entry-form button:hover { background: var(--accent);}
.entry-error { margin-top: .15em; color: #b3261e; font-size:.97em;
min-height:12px;}
.entry-modal.hidden { display:none;}
body.modal-open { overflow-y: hidden;}
.modal-overlay {
position: fixed; top:0; left:0; right:0; bottom:0;
background: rgba(90,109,229,0.08); display:flex; justify-content:center;
align-items:center;
z-index:6000; backdrop-filter: blur(8px);}
.hidden { display:none;}
.modal {
background: var(--modal-bg);
color: var(--primary);
border-radius: 11px;
width: 94vw; max-width: 353px;
padding: 1.7em 1.1em 1.7em 1.1em; box-shadow: var(--shadow);
position: relative;}
.close-btn { position: absolute; right: 13px; top: 11px; font-size:1.15em;
color:var(--danger); background:none; border:none; cursor: pointer;}
#modalSemester {margin-top:0;color:var(--primary);}
#subjectForm label { font-weight: 600; margin-bottom:.15em; display:block;}
#subjectForm input[type="number"] {
width: 51px; font-size: 1em; padding: .18em .6em;
border-radius: 1em; border:1.05px solid var(--primary); outline:none;
margin-left:.18em; background:#f3f7fc;
}
#subjectRows {margin: .6em 0;}
.subjectRow { display: flex; gap:.6em; margin-bottom:.39em; align-items:center;
font-size:.95em;}
.select-wrap { position: relative; display: inline-block; width: 110px;}
select.gradeSel, select.creditSel {
width: 100%;
appearance: none;
background: #fff;
border: 1.4px solid #bcd2fa;
color: #1665d8;
font-size: 1em;
font-weight: 500;
padding: 0.41em 1.8em 0.41em 0.8em;
border-radius: 9px;
transition: border .18s, box-shadow .18s;
outline: none;
box-shadow: 0 1.5px 9px #227c9d0C;
cursor: pointer;
}
select.gradeSel:focus, select.creditSel:focus {
border-color: #1665d8;
background: #f0f8ff;
}
.dropdown-arrow {
position: absolute;
right: 12px;
top: 50%;
pointer-events: none;
font-size: 0.9em;
color: #1665d8;
transform: translateY(-50%);
}
@media (max-width:440px) {
.select-wrap { width: 88px;}
select.gradeSel, select.creditSel { font-size: 0.97em;}
}
.modal-save {
background: linear-gradient(89deg,#1976d2 60%,#478ae2 160%);
color: #fff; font-weight: 600; border:none; border-radius:1em; font-size:.98em;
padding:.41em 1.12em; margin-top:.39em; box-shadow: 0 1.5px 6px #478ae277;
cursor:pointer; transition:background .13s;}
.modal-save:hover { background: linear-gradient(90deg,#478ae2 60%,#1976d2
100%);}
#sgpaOutput { font-size: .99em; margin-top: .6em; text-align:center;
font-weight:bold; color:var(--primary);}
#toast { position: fixed; bottom: 83px; right: 18px; background:var(--accent);
color: #fff; border-radius: 1em; padding:.5em .9em; font-weight:600;
font-size:.98em; opacity:0; pointer-events:none; z-index:10000; box-shadow: 0
4px 8px #478ae249; transition:opacity .18s;}
#toast.show { opacity:1;}

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
if (state.users.includes(val)) { err.textContent = "User already exists.";
return;}
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
'<div
    style="grid-column:1/-1; padding:2em 0; text-align:center; color:#888;">Please
    add a user!</div>';
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
document.getElementById('modalSemester').textContent = `Semester
${SEMESTERS[idx]}`;
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
const count = Math.max(1, Math.min(15,
parseInt(document.getElementById('subjectCount').value, 10) || 9));
const container = document.getElementById('subjectRows');
container.innerHTML = '';
for (let i = 0; i < count; i++) {
// Default: grade is A+ (10) unless already set
const gradeSelected = (existing[i] && typeof existing[i].grade !== 'undefined'
&& existing[i].grade !== '') ? existing[i].grade : 10;
const creditSelected = (existing[i] && typeof existing[i].credit !==
'undefined') ? existing[i].credit : 3;
const row = document.createElement('div');
row.className = 'subjectRow';
row.innerHTML = `
<label>Grade:
    <div class="select-wrap">
        <select class="gradeSel" required>
            <option value disabled${gradeSelected === '' ? ' selected' :
                ''}>Choose Grade</option>
            ${GRADES.map(g =>
            `<option value="${g.value}" ${gradeSelected == g.value ? ' selected'
                : ''}>${g.label}</option>`
            ).join('')}
        </select>
        <span class="dropdown-arrow">&#9662;</span>
    </div>
</label>
<label>Credit:
    <div class="select-wrap">
        <select class="creditSel">
            ${CREDIT_OPTIONS.map(
            c => `<option value="${c}" ${c == creditSelected ? ' selected' :
                ''}>${c}</option>`
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
const totalCredits = subjects.reduce((sum, sub) => sum + (sub.grade !== '' ?
sub.credit : 0), 0);
const sgpa = totalCredits ? (subjects.reduce((sum, sub) => sum + (sub.grade !==
'' ? sub.grade * sub.credit : 0), 0) / totalCredits) : null;
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
const sgpa = totalCredits ? (valSubs.reduce((sum, sub) => sum + sub.grade *
sub.credit, 0) / totalCredits) : null;
sgpaDiv.textContent = (sgpa != null && !isNaN(sgpa)) ? 'SGPA: ' +
sgpa.toFixed(2) : '';
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

{
"name": "SGPA App",
"short_name": "SGPA",
"start_url": ".",
"display": "standalone",
"background_color": "#ffffff",
"theme_color": "#1665d8",
"description": "A simple SGPA & CGPA Calculator",
"icons": [
{
"src": "icon-192.png",
"sizes": "192x192",
"type": "image/png"
},
{
"src": "icon-512.png",
"sizes": "512x512",
"type": "image/png"
}
]
}

self.addEventListener('install', function(e){self.skipWaiting();});
self.addEventListener('fetch', function(event) {});
