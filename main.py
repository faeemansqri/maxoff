import requests
import json
import re
from rich.console import Console
from rich.table import Table
from rich.panel import Panel
from rich.prompt import Prompt
from rich.text import Text
from rich.align import Align
from rich import box

# MaxOff - OSINT Phone Information Tool
# GitHub: https://github.com/faeemansqri/maxoff
# Created by: Mando

console = Console()

def print_responsive_banner():
    """Print responsive banner using Rich's built-in features"""
    # Main title
    title = Text("MAXOFF", style="bold cyan", justify="center")
    subtitle = Text("OSINT Phone Information Tool", style="bold yellow", justify="center")
    creator = Text("Created by: Mando v1.0", style="bold green", justify="center")
    
    # Create panel with Rich's styling
    banner_panel = Panel(
        f"{title}\n{subtitle}\n{creator}",
        style="cyan",
        box=box.ROUNDED,
        padding=(1, 2),
        expand=False
    )
    
    console.print()
    console.print(Align.center(banner_panel))
    console.print()

# Display responsive banner on startup
print_responsive_banner()

def validate_phone_number(num):
    """Validate and proof phone number input"""
    if not num:
        console.print("[bold red]❌ Phone number cannot be empty![/bold red]")
        return False
    
    # Remove any spaces or hyphens
    num = re.sub(r'[\s\-]', '', num)
    
    # Check if it's numeric
    if not num.isdigit():
        console.print("[bold red]❌ Only digits allowed! Remove letters or special chars[/bold red]")
        return False
    
    # Check length (Indian phone numbers are 10 digits)
    if len(num) < 10:
        console.print(f"[bold red]❌ Phone too short! Got {len(num)} digits, need 10+[/bold red]")
        return False
    
    if len(num) > 15:
        console.print("[bold red]❌ Phone number too long! Max 15 digits[/bold red]")
        return False
    
    return num

def getnuminfo(num):
    key = "96temp&num" 
    url = f"https://anon-num-info.vercel.app/num?key={key}={num}"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        return {"error": "Could not retrieve information."}

def format_address(addr):
    """Clean up address string"""
    return addr.replace("!", ", ").strip()

while True:
    console.print()
    user_input = Prompt.ask(
        "[bold cyan]📱 Enter phone number[/bold cyan]",
        default="",
        show_default=False
    ).strip()
    
    if not user_input:
        console.print("[bold yellow]⚠️  Please enter a valid phone number[/bold yellow]")
        continue
    
    if user_input.lower() in ['quit', 'exit', 'q', 'bye']:
        console.print("\n[bold green]✓ Thanks for using MaxOff! Goodbye 👋[/bold green]\n")
        break
    
    validated_num = validate_phone_number(user_input)
    if not validated_num:
        continue
    
    console.print("\n[bold yellow]⏳ Fetching data...[/bold yellow]")
    info = getnuminfo(validated_num)

    if "response" in info and "data" in info["response"]:
        records = info["response"]["data"]
        
        if len(records) == 0:
            console.print("[bold yellow]⚠️  No records found for this number[/bold yellow]")
            continue
        
        console.print(f"\n[bold green]✓ Found {len(records)} record(s)[/bold green]\n")
        
        for idx, record in enumerate(records, 1):
            # Create vertical table for each entry
            table = Table(
                title=f"[bold magenta]📋 RESULT #{idx} / {len(records)}[/bold magenta]",
                box=box.ROUNDED,
                show_header=True,
                header_style="bold cyan"
            )
            
            table.add_column("Field", style="cyan", width=18)
            table.add_column("Value", style="green", no_wrap=False)
            
            table.add_row("👤 Name", record.get("name", "N/A"))
            table.add_row("👨‍👨‍👦 Father's Name", record.get("fname", "N/A"))
            table.add_row("📱 Phone Number", f"[bold yellow]{record.get('num', 'N/A')}[/bold yellow]")
            table.add_row("📞 Alternate", record.get("alt", "N/A") or "—")
            table.add_row("📍 Address", format_address(record.get("address", "N/A")))
            table.add_row("🌐 Circle", f"[bold blue]{record.get('circle', 'N/A')}[/bold blue]")
            table.add_row("🆔 Aadhar", record.get("aadhar", "N/A") or "—")
            table.add_row("📧 Email", record.get("email", "N/A") or "—")
            
            console.print(table)
            console.print()
            
        # Summary panel
        summary = Panel(
            f"[bold green]✓ Retrieved {len(records)} record(s) successfully[/bold green]",
            style="bold cyan",
            expand=False
        )
        console.print(summary)
    else:
        console.print("[bold red]❌ No data found or API error occurred[/bold red]")
        if "error" in info:
            console.print(f"[dim red]Details: {info['error']}[/dim red]")
