import { Flex, Spacer, Separator } from '@artsy/palette'
import React from "react"
import { Link } from "react-router-dom"
import {Account} from './account'
import styled from 'styled-components';


const Header = () => {
  return (
    <>
      <Flex flexDirection="row" flexWrap="nowrap" mt={2} justifyContent="space-between" alignContext="top" style={ { width: "100%"  }}>
        <StyledLink to={"/"}>
          <span style={{fontSize: 33}}>D</span><span style={{fontSize: 12}}>o</span><span style={{fontSize: 33}}>.B</span><span style={{fontSize: 12}}>ar</span>
        </StyledLink>
        <Account/>
      </Flex>
      <Separator mb={2} mt={1}/>
    </>
  )
}

export default Header

const StyledLink = styled(Link)`
    text-decoration: none;

    &:focus, &:hover, &:visited, &:link, &:active {
        text-decoration: none;
    }
`;