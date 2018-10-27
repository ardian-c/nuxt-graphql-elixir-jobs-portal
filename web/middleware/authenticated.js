export default function({ app, redirect }) {
  const hasToken = !!app.$apolloHelpers.getToken();

  if(!hasToken) {
    //error({ errorCode: 503, message: 'Not authorized!'})
    return redirect("/login");
  }
}
