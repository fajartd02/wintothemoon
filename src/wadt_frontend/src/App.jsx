App.jsx

import { useEffect, useState } from 'react';
import { Actor, HttpAgent } from "@dfinity/agent";
import { AuthClient } from "@dfinity/auth-client";

function App() {
  const [identityUrl, setIdentityUrl] = useState('');
  const [userIdentityId, setUserIdentityId] = useState('');


  // The interface of the whoami canister
  const webapp_idl = ({ IDL }) => {
    return IDL.Service({ whoami: IDL.Func([], [IDL.Principal], ["query"]) });
  };

  async function customIILogin() {
    if (process.env.DFX_NETWORK === "local") {
      setIdentityUrl(`http://${process.env.CANISTER_ID_INTERNET_IDENTITY}.localhost:4943`);
    } else if (process.env.DFX_NETWORK === "ic") {
      setIdentityUrl(`https://${process.env.CANISTER_ID_INTERNET_IDENTITY}.ic0.app`)
    } else {
      setIdentityUrl(`https://${process.env.CANISTER_ID_INTERNET_IDENTITY}.dfinity.network`)
    }

    const authClient = await AuthClient.create();

    if (await authClient.isAuthenticated()) {
      const identity = await authClient.getIdentity();
      const principal = identity.getPrincipal();
      console.log(principal.toString());
    } else {
      await authClient.login({
        identityProvider: identityUrl,
        onSuccess: async () => {
          const identity = await authClient.getIdentity();
          const principal = identity.getPrincipal();
          console.log(principal.toString());
        }
      });
    }
  }

  // useEffect(async () => {
  //   const isLoggedIn = async () => {
  //     const authClient = await AuthClient.create();
  //     if (await authClient.isAuthenticated()) {
  //       const identity = await authClient.getIdentity();
  //       console.log(identity);
  //     } else {
  //       console.log("not login yet");
  //     }
  //   }

  //   await isLoggedIn();
  // }, [])

  return (
    <main>
      <img src="/logo2.svg" alt="DFINITY logo" />
      <br />
      <br />
      <form action="#" onSubmit={customIILogin}>
        <button type="submit">Login!</button>
      </form>
      <section id="identityId">{userIdentityId}</section>

    </main>
  );
}

export default App;

