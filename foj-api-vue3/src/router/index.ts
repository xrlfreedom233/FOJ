import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/stores/user'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      name: 'home',
      component: () => import('@/views/Home.vue'),
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('@/views/Login.vue'),
      meta: { guest: true },
    },
    {
      path: '/register',
      name: 'register',
      component: () => import('@/views/Register.vue'),
      meta: { guest: true },
    },
    {
      path: '/reset-password',
      name: 'reset-password',
      component: () => import('@/views/ResetPassword.vue'),
      meta: { guest: true },
    },
    {
      path: '/admin/login',
      name: 'admin-login',
      component: () => import('@/views/AdminLogin.vue'),
      meta: { guest: true },
    },
    {
      path: '/admin',
      component: () => import('@/views/AdminLayout.vue'),
      meta: { requiresAuth: true, requiresAdmin: true },
      children: [
        { path: '', name: 'admin', component: () => import('@/views/AdminHome.vue') },
        { path: 'dashboard', redirect: '/admin' },
        { path: 'user', name: 'admin-user', component: () => import('@/views/AdminList.vue'), meta: { requiresSuperAdmin: true, adminResource: 'users' } },
        { path: 'announcement', name: 'admin-announcement', component: () => import('@/views/AdminList.vue'), meta: { adminResource: 'announcements' } },
        { path: 'conf', name: 'admin-conf', component: () => import('@/views/AdminConfig.vue'), meta: { requiresSuperAdmin: true, adminConfig: 'web' } },
        { path: 'switch', name: 'admin-switch', component: () => import('@/views/AdminConfig.vue'), meta: { requiresSuperAdmin: true, adminConfig: 'switch' } },
        { path: 'problems', name: 'admin-problem-list', component: () => import('@/views/AdminList.vue'), meta: { adminResource: 'problems' } },
        { path: 'problem/create', name: 'admin-create-problem', component: () => import('@/views/AdminJsonEditor.vue'), meta: { adminEditor: 'problem' } },
        { path: 'problem/edit/:problemId', name: 'admin-edit-problem', component: () => import('@/views/AdminJsonEditor.vue'), meta: { adminEditor: 'problem' } },
        { path: 'problem/tag', name: 'admin-problem-tag', component: () => import('@/views/AdminTagManager.vue') },
        { path: 'problem/batch-operation', name: 'admin-problem-batch-operation', component: () => import('@/views/AdminProblemBatch.vue') },
        { path: 'contest', name: 'admin-contest-list', component: () => import('@/views/AdminList.vue'), meta: { adminResource: 'contests' } },
        { path: 'contest/create', name: 'admin-create-contest', component: () => import('@/views/AdminContestEditor.vue') },
        { path: 'contest/:contestId/edit', name: 'admin-edit-contest', component: () => import('@/views/AdminContestEditor.vue') },
        { path: 'contest/:contestId/announcement', name: 'admin-contest-announcement', component: () => import('@/views/AdminList.vue'), meta: { adminResource: 'contest-announcements' } },
        { path: 'contest/:contestId/problems', name: 'admin-contest-problem-list', component: () => import('@/views/AdminList.vue'), meta: { adminResource: 'contest-problems' } },
        { path: 'contest/:contestId/problem/create', name: 'admin-create-contest-problem', component: () => import('@/views/AdminJsonEditor.vue'), meta: { adminEditor: 'contest-problem' } },
        { path: 'contest/:contestId/problem/:problemId/edit', name: 'admin-edit-contest-problem', component: () => import('@/views/AdminJsonEditor.vue'), meta: { adminEditor: 'contest-problem' } },
      ],
    },
    {
      path: '/problems',
      name: 'problems',
      component: () => import('@/views/Problems.vue'),
    },
    {
      path: '/problem/:pid',
      name: 'problem',
      component: () => import('@/views/ProblemDetail.vue'),
    },
    {
      path: '/submissions',
      name: 'submissions',
      component: () => import('@/views/Submissions.vue'),
    },
    {
      path: '/submission/:sid',
      name: 'submission',
      component: () => import('@/views/SubmissionDetail.vue'),
    },
    {
      path: '/contests',
      name: 'contests',
      component: () => import('@/views/Contests.vue'),
    },
    {
      path: '/contest/:cid',
      name: 'contest',
      component: () => import('@/views/ContestDetail.vue'),
    },
    {
      path: '/contest/:cid/problem/:index',
      name: 'contest-problem',
      component: () => import('@/views/ContestProblem.vue'),
    },
    {
      path: '/rank',
      name: 'rank',
      component: () => import('@/views/Rank.vue'),
    },
    {
      path: '/profile',
      name: 'profile',
      component: () => import('@/views/Profile.vue'),
      meta: { requiresAuth: true },
    },
    {
      path: '/:pathMatch(.*)*',
      name: 'not-found',
      component: () => import('@/views/NotFound.vue'),
    },
  ],
})

router.beforeEach((to, _from, next) => {
  const userStore = useUserStore()

  if (to.meta.requiresAuth && !userStore.isLoggedIn) {
    next({ name: to.meta.requiresAdmin ? 'admin-login' : 'login', query: { redirect: to.fullPath } })
  } else if (to.meta.requiresAdmin && !userStore.isAdmin) {
    next({ name: 'admin-login', query: { redirect: to.fullPath } })
  } else if (to.meta.requiresSuperAdmin && !userStore.isSuperAdmin) {
    next({ name: 'admin-login', query: { redirect: to.fullPath } })
  } else if (to.meta.guest && userStore.isLoggedIn) {
    next({ name: to.name === 'admin-login' && userStore.isAdmin ? 'admin' : 'home' })
  } else {
    next()
  }
})

export default router
