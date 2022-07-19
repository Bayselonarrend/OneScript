﻿/*----------------------------------------------------------
This Source Code Form is subject to the terms of the
Mozilla Public License, v.2.0. If a copy of the MPL
was not distributed with this file, You can obtain one
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/

using System.Reflection;
using OneScript.Compilation.Binding;
using OneScript.Contexts;

namespace OneScript.Runtime.Binding
{
    internal class BslBoundMethodSymbol : BslMethodSymbol, IBoundSymbol
    {
        public object Target { get; set; }
    }
}