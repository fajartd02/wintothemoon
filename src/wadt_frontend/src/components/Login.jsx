import { AuthClient } from "@dfinity/auth-client";
import { Button, Grid, GridItem, Text, VStack } from "@chakra-ui/react";

const Login = ({ setIsAuthenticated }) => {
    const login = async () => {
        let identityURL = '';

        if (process.env.DFX_NETWORK === "local") {
            identityURL = `http://${process.env.CANISTER_ID_INTERNET_IDENTITY}.localhost:4943`;
        } else if (process.env.DFX_NETWORK === "ic") {
            identityURL = `https://${process.env.CANISTER_ID_INTERNET_IDENTITY}.ic0.app`;
        } else {
            identityURL = `https://${process.env.CANISTER_ID_INTERNET_IDENTITY}.dfinity.network`;
        }

        const authClient = await AuthClient.create();

        await authClient.login({
            identityProvider: identityURL,
            onSuccess: async () => {
                setIsAuthenticated(true);
            }
        });
    };

    return (
        <Grid templateColumns="repeat(2, 1fr)" p={20}>
            <GridItem>
                <VStack spacing={5} alignItems="start">
                    <Text fontSize={64}>Will Autonomous Decentralization</Text>
                    <Button colorScheme="gray" onClick={login}>Login</Button>
                </VStack>
            </GridItem>
        </Grid>
    );
};

export default Login;