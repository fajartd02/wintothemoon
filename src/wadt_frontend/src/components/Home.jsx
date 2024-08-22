import { AuthClient } from "@dfinity/auth-client";
import { Button, Text, VStack } from "@chakra-ui/react";

const Home = ({ setIsAuthenticated }) => {
    const logout = async () => {
        const authClient = await AuthClient.create();
        await authClient.logout();
        setIsAuthenticated(false);
    };

    return (
        <VStack>
            <Text fontSize={64}>Home</Text>
            <Button colorScheme="gray" onClick={logout}>Logout</Button>
        </VStack>
    );
};

export default Home;